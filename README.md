# campaign-analyser

> Campaign performance analysis for [ProductClank](https://www.productclank.com) agents and creators.

An [Agent Skill](https://agentskills.io/) that turns raw campaign data into actionable insights — ROI per campaign, keyword patterns, content style analysis, and a concrete next-campaign strategy.

---

## What it does

When asked to analyse campaign performance, `campaign-analyser` runs a four-step review:

1. **Data collection** — fetches live campaign structure via ProductClank API, or accepts pasted campaign data in manual mode
2. **ROI calculation** — calculates points-per-credit for every campaign and ranks them
3. **Pattern analysis** — identifies what keywords, content styles, and post volumes drive the best results
4. **Recommendations** — produces a specific next-campaign strategy based on historical patterns

It then outputs a structured performance report with rankings, insights, and an actionable plan.

---

## Two modes

| Mode | When to use | Requirement |
|------|------------|-------------|
| API mode | You have a ProductClank API key | `PRODUCTCLANK_API_KEY` env var |
| Manual mode | No API key, or testing | Paste campaign data directly |

Both modes produce the same structured report.

**Note on API mode:** The ProductClank agent API currently returns campaign structure (names, keywords, dates) and post counts. Points earned and $PRO per campaign are not yet exposed via API — the skill will prompt you to enter these manually after fetching. See [Future capabilities](#future-capabilities) below.

---

## Install

Load the skill into your agent:

```
https://github.com/AyushVerma7861/campaign-analyser/blob/main/SKILL.md
```

Or fetch raw:

```bash
curl -s https://raw.githubusercontent.com/AyushVerma7861/campaign-analyser/main/SKILL.md
```

---

## Quick start

```bash
# Pull campaign structure from the ProductClank API
chmod +x scripts/fetch-data.sh
PRODUCTCLANK_API_KEY=your_key ./scripts/fetch-data.sh

# Paste the output into your agent and say:
# "Analyse this campaign data and give me a performance report."
# The agent will ask for points and $PRO earned per campaign, then calculate ROI.
```

No API key? Use the sample data in `QUICKSTART.md` to test immediately — no setup needed.

---

## File structure

```
campaign-analyser/
├── SKILL.md                          # Core skill — load this into your agent
├── README.md                         # You are here
├── QUICKSTART.md                     # Get running in 5 minutes + sample test data
├── CHANGELOG.md                      # Version history
├── references/
│   ├── METRICS.md                    # Metric definitions, edge cases, alternative signals
│   └── API_REFERENCE.md              # ProductClank API endpoints, what is/isn't available
└── scripts/
    └── fetch-data.sh                 # Full data pull with offset pagination
```

---

## Future capabilities

These features are planned and will be enabled automatically once ProductClank exposes the relevant data through their agent API:

**Points and $PRO per campaign**
Currently, points earned and $PRO per campaign are not returned by the agent API. Once ProductClank adds these fields, API mode will calculate ROI fully automatically — no manual input required.

**Real-time ROI tracking**
With live points data, the skill will be able to track ROI as a campaign runs — not just after it ends.

**Season-over-season comparison**
With historical points data accessible via API, the skill will compare performance across ProductClank seasons and flag whether scoring changes affect campaign strategy.

**$PRO token-based ROI**
Once $PRO balance deltas are accessible per campaign, the skill will calculate a second ROI metric — $PRO earned per credit spent — giving a token-denominated view alongside the points-based one.

**Agent leaderboard context**
With access to leaderboard standing via API, the skill will contextualise your ROI against other agents in the same season — not just your own historical data.

If you are a ProductClank developer and want to help enable these features, the relevant fields needed are: `points_earned` and `pro_earned` per campaign in the `GET /agents/campaigns/{id}` response, and an overall agent stats endpoint.

---

## Built for the ProductClank ecosystem

This skill is registered with the [ProductClank Skill Registry](https://www.productclank.com/superfluid/skills) and follows the [Agent Skills](https://agentskills.io/) standard (v1, Anthropic).

**Useful links:**
- [ProductClank Agents](https://www.productclank.com/agents)
- [Skill Registry — Season 6](https://www.productclank.com/superfluid/skills)
- [Skill-Leads programme](https://www.productclank.com/skill-leads)
- [Official ProductClank agent skills](https://github.com/covariance-network/productclank-agent-skill)

---

## Author

**RAVEN_SPARK** — [@RAVEN_SPARK7](https://x.com/RAVEN_SPARK7) on X

---

## License

MIT
