//! 通用游戏 wiki 查询工具。
//!
//! 通过 `site` 参数选择要查询的 wiki 站点，从该站点的实时页面抓取
//! 角色/武器/攻略等信息并转成 Markdown 摘录。站点列表、页面路径模板
//! 与中文昵称别名表均可扩展：新增一个游戏只需在 `SITES` 里补一条配置，
//! 无需再写一个专属工具。
//!
//! 与本地知识库（kb/）互补：知识库提供稳定的中文背景故事，本工具提供
//! 实时的技能数值、配装与版本数据。

use super::{html_conversion, http_response, ToolRegistry, ToolSpec};
use anyhow::{bail, Result};
use serde_json::{json, Value};
use std::time::Duration;

const MAX_PAGE_BYTES: usize = 2 * 1024 * 1024;
const MAX_OUTPUT_CHARS: usize = 16_000;

/// 一个 wiki 站点的通用描述：只要给出页面基础 URL、路径模板与可选的中文
/// 昵称别名表，即可复用同一套查询逻辑。
struct WikiSite {
    /// 站点标识（`site` 参数取值），如 "wuwa"。
    key: &'static str,
    /// 站点显示名，用于文案与错误提示。
    display: &'static str,
    /// 页面基础 URL，如 "https://wuthering.gg"。
    page_base: &'static str,
    /// 页面路径模板，`{}` 占位为归一化后的条目 slug，如 "/characters/{}"。
    page_path: &'static str,
    /// 中文昵称 -> 站点 slug 的别名映射（仅当该站点需要时提供）。
    aliases: &'static [(&'static str, &'static str)],
}

/// 已内置支持的 wiki 站点。新增站点只需在此追加一条配置。
const SITES: &[WikiSite] = &[WikiSite {
    key: "wuwa",
    display: "鸣潮",
    page_base: "https://wuthering.gg",
    page_path: "/characters/{}",
    aliases: &[
        ("漂泊者", "rover"),
        ("今汐", "jinhsi"),
        ("忌炎", "jiyan"),
        ("凌阳", "lingyang"),
        ("白芷", "baizhi"),
        ("秧秧", "yangyang"),
        ("鉴心", "jianxin"),
        ("卡卡罗", "calcharo"),
        ("卡卡", "calcharo"),
        ("安可", "encore"),
        ("长离", "changli"),
        ("椿", "camellya"),
        ("卡提", "cartethyia"),
        ("菲比", "phoebe"),
        ("珂莱塔", "carlotta"),
        ("丹瑾", "danjin"),
        ("维里奈", "verina"),
        ("守岸人", "shorekeeper"),
    ],
}];

pub fn register(registry: &mut ToolRegistry) {
    registry.register(ToolSpec::new(
        "query_wiki",
        "Query a game wiki for real-time character/weapon/item/guide info. Select the wiki via the 'site' parameter. Returns a markdown excerpt of the relevant page. Use for current version data that may not be in the local knowledge base.",
        json!({
            "type":"object",
            "properties":{
                "query":{"type":"string","description":"Character/weapon/item name, supports Chinese or English (e.g. Rover, Jinhsi, 今汐, 忌炎)."},
                "site":{"type":"string","enum":["","wuwa"],"description":"Which wiki to query. Empty = auto pick the default site."}
            },
            "required":["query"],
            "additionalProperties":false
        }),
        |args| async move { query(args).await },
    ));
}

async fn query(args: Value) -> Result<String> {
    let site_key = args
        .get("site")
        .and_then(Value::as_str)
        .unwrap_or("")
        .trim();
    // 未指定 site 或找不到时，回退到默认（首个）站点。
    let site = SITES
        .iter()
        .find(|s| s.key == site_key)
        .or_else(|| SITES.first())
        .expect("at least one wiki site configured");

    let query = args
        .get("query")
        .and_then(Value::as_str)
        .unwrap_or("")
        .trim()
        .to_string();
    if query.is_empty() {
        bail!("query is required (character/weapon/item name)")
    }

    let slug = to_slug(site, &query);
    let url = format!("{}{}", site.page_base, site.page_path.replace("{}", &slug));

    // 兜底：页面请求失败时给出友好引导，而不是让整次查询报错。
    let html = match fetch_page(&url).await {
        Ok(html) => html,
        Err(_) => {
            return Ok(serde_json::to_string_pretty(&json!({
                "success": false,
                "site": site.key,
                "display": site.display,
                "query": query,
                "message": format!(
                    "未在{}({})找到「{}」的页面。可尝试英文名，或使用知识库检索《{}》背景故事。",
                    site.display, site.page_base, query, site.display
                ),
            }))?);
        }
    };

    let markdown = html_conversion::to_markdown(html).await?;
    let excerpt = clip(&markdown);
    Ok(serde_json::to_string_pretty(&json!({
        "success": true,
        "site": site.key,
        "display": site.display,
        "query": query,
        "slug": slug,
        "url": url,
        "excerpt": excerpt,
    }))?)
}

/// 将中文昵称或英文名归一化为站点 slug（小写、连字符）。
/// 先查该站点的别名表，未命中再按英文名归一化。
fn to_slug(site: &WikiSite, name: &str) -> String {
    for (alias, slug) in site.aliases {
        if name.contains(alias) {
            return (*slug).to_string();
        }
    }
    // 英文名：转小写并移除空白/特殊字符。
    let normalized: String = name
        .chars()
        .map(|ch| {
            if ch.is_ascii_alphanumeric() {
                ch.to_ascii_lowercase()
            } else {
                '-'
            }
        })
        .collect();
    normalized
        .split('-')
        .filter(|part| !part.is_empty())
        .collect::<Vec<_>>()
        .join("-")
}

async fn fetch_page(url: &str) -> Result<String> {
    let client = reqwest::Client::builder()
        .timeout(Duration::from_secs(12))
        .user_agent("gqy/0.1 (+wiki助手)")
        .build()
        .expect("valid reqwest client");
    let response = client.get(url).send().await?.error_for_status()?;
    http_response::read_text(response, MAX_PAGE_BYTES).await
}

fn clip(text: &str) -> String {
    if text.chars().count() <= MAX_OUTPUT_CHARS {
        text.to_string()
    } else {
        format!(
            "{}\n...[truncated to {MAX_OUTPUT_CHARS} chars]",
            text.chars().take(MAX_OUTPUT_CHARS).collect::<String>()
        )
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn slugifies_english_names() {
        assert_eq!(to_slug(&SITES[0], "Rover"), "rover");
        assert_eq!(to_slug(&SITES[0], "Jinhsi"), "jinhsi");
        assert_eq!(to_slug(&SITES[0], "Jiyan"), "jiyan");
        assert_eq!(to_slug(&SITES[0], "Lingyang"), "lingyang");
        assert_eq!(to_slug(&SITES[0], "Rover (Electro)"), "rover-electro");
    }

    #[test]
    fn slugifies_chinese_aliases() {
        assert_eq!(to_slug(&SITES[0], "今汐"), "jinhsi");
        assert_eq!(to_slug(&SITES[0], "忌炎"), "jiyan");
        assert_eq!(to_slug(&SITES[0], "凌阳"), "lingyang");
        assert_eq!(to_slug(&SITES[0], "漂泊者"), "rover");
    }

    #[test]
    fn clips_long_text() {
        let long = "x".repeat(20_000);
        let clipped = clip(&long);
        assert!(clipped.len() < 20_000);
        assert!(clipped.contains("truncated"));
    }

    #[test]
    fn picks_site_by_key() {
        let site = SITES.iter().find(|s| s.key == "wuwa").unwrap();
        assert_eq!(site.key, "wuwa");
        assert!(site.page_base.contains("wuthering"));
    }
}
