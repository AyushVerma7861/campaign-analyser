# Changelog

## [1.0.1] — 2026-07-04

### Fixed
- Removed non-existent `/agents/me` endpoint from SKILL.md and API_REFERENCE.md
- Replaced with correct `/agents/credits/balance` endpoint
- Fixed `campaigns[].posts_count` → `campaign.stats.total_posts` (correct field from detail endpoint)
- Fixed pagination in `fetch-data.sh` from cursor-based to offset-based (`?limit=N&offset=N`)
- Updated METRICS.md: points and $PRO marked as manual input (not yet in API)
- Updated SKILL.md: API mode now clearly explains it fetches structure + post counts, and prompts user for points and $PRO

### Added
- Alternative engagement metric (submission rate) in METRICS.md for when points data is unavailable
- Future capabilities section in README.md — documents what the skill will do once ProductClank exposes points/PRO data via API
- Note in README clarifying current API mode scope

## [1.0.0] — 2026-07-04

### Added
- Initial release of `campaign-analyser` for the ProductClank ecosystem
- Dual-mode operation: API mode with live ProductClank data, manual mode with pasted campaign data
- Four-step analysis protocol: data collection, ROI calculation, pattern analysis, recommendations
- ROI benchmark table: Excellent / Good / Average / Poor ratings per campaign
- Structured performance report with campaign rankings, top/worst performer breakdown, and next-campaign strategy
- `references/METRICS.md` — metric definitions, edge case handling, ROI calculation for partial data
- `references/API_REFERENCE.md` — ProductClank API endpoints, pagination handling, error codes
- `scripts/fetch-data.sh` — complete data pull with pagination and auto ROI calculation
- Sample campaign data in `QUICKSTART.md` for testing without an API key

### Follows
- [Agent Skills](https://agentskills.io/) standard v1 (Anthropic)
- ProductClank Skill Registry — Season 6
