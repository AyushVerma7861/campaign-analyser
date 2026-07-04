---
name: campaign-analyser
description: Campaign performance analysis for ProductClank agents. Use when asked to analyse campaign results, calculate ROI, compare campaigns, find what worked, identify patterns, or plan the next campaign strategy. Works in API mode with a ProductClank API key or in manual mode when the user pastes campaign data directly.
license: MIT
compatibility: Designed for the ProductClank ecosystem. API mode requires a ProductClank API key and curl. Manual mode works with any agent — no API key needed.
metadata:
  author: RAVEN_SPARK
  version: "1.0.1"
---

# Campaign Analyser 📊

Turns raw ProductClank campaign data into actionable insights — ROI per campaign, keyword patterns, content style analysis, and a concrete next-campaign strategy.

## Gotchas

- Credits are spent in two places: campaign creation (10 credits) and post generation (12 credits per post). ROI must account for both — not just creation cost.
- Points and $PRO are different. Points affect leaderboard rank. $PRO is the token reward. Track both separately.
- A campaign with high points but high credit spend may have worse ROI than a smaller campaign. Always calculate points-per-credit, not raw points.
- **The ProductClank agent API does not currently expose per-campaign points earned or $PRO balance.** API mode fetches campaign structure and post counts. Points and $PRO must be entered manually — the agent will prompt for them after fetching.
- If the user has no API key, switch to manual mode immediately — ask them to paste their campaign data. Do not get stuck waiting for an API key.
- The ProductClank API base is `https://api.productclank.com/api/v1`. Never call `app.productclank.com` — that is the web UI, not the agent API.
- Campaign data from the API is paginated using offset. Check the `total` field and fetch additional pages using `?offset=N` until all campaigns are collected.

## Mode detection

Check whether the user has a ProductClank API key:

- **API mode** — user provides `PRODUCTCLANK_API_KEY` or it exists as an env var → fetch campaign structure and post counts automatically, then prompt for points and $PRO
- **Manual mode** — no API key → ask user to paste full campaign data, then analyse what they provide

Both modes produce the same structured report.

## Step 1 — Collect campaign data

### API mode

API mode fetches campaign structure (names, keywords, dates) and post counts. It cannot fetch points earned or $PRO — those must be provided by the user.

```bash
# Get credit balance
curl -s https://api.productclank.com/api/v1/agents/credits/balance \
  -H "Authorization: Bearer $PRODUCTCLANK_API_KEY" | jq .

# Get campaign list
curl -s https://api.productclank.com/api/v1/agents/campaigns \
  -H "Authorization: Bearer $PRODUCTCLANK_API_KEY" | jq .

# Get full stats for a specific campaign
curl -s https://api.productclank.com/api/v1/agents/campaigns/CAMPAIGN_ID \
  -H "Authorization: Bearer $PRODUCTCLANK_API_KEY" | jq .
```

Post count is at `campaign.stats.total_posts` in the detail response.

See `scripts/fetch-data.sh` for a complete data pull with pagination handling.

After fetching, display the pre-filled table to the user:

> "I've fetched your campaign structure. I can see [N] campaigns with their keywords and post counts. The ProductClank API doesn't expose points earned or $PRO per campaign yet — please fill those in:
>
> Campaign: [name] | Posts: [X] | Points earned: ? | $PRO earned: ?"

Then proceed once the user provides the missing values.

### Manual mode

Ask the user:

> "Please paste your campaign data. Include for each campaign: campaign name, credits spent, posts generated, points earned, $PRO earned if any, and the keywords or product you were promoting."

Accept data in any format — table, list, or freeform text. Extract the values you need.

## Step 2 — Calculate ROI for each campaign

For every campaign:

```
credits_spent = 10 (creation) + (12 × posts_generated)
roi_ratio     = points_earned ÷ credits_spent
```

ROI benchmark:

| ROI ratio | Rating |
|-----------|--------|
| > 10 points/credit | 🟢 Excellent |
| 5–10 points/credit | 🟡 Good |
| 2–5 points/credit  | 🟠 Average |
| < 2 points/credit  | 🔴 Poor |

Rank all campaigns from highest to lowest ROI. Note the top performer and the worst performer.

## Step 3 — Identify patterns

Across all campaigns, look for patterns in:

**Keywords and topics**
- Which product categories or keywords appear in top-performing campaigns?
- Which appear in poor performers?

**Content style**
- Did question-style replies outperform statement-style replies?
- Were data-driven posts (with numbers/stats) better than opinion posts?
- Were shorter posts better than longer ones?

**Post volume**
- Did campaigns with more generated posts earn proportionally more points, or did returns diminish?
- What was the optimal number of posts per campaign?

**Timing** (if timestamps are available)
- Were certain days or times more effective?

Note each pattern clearly — the recommendations in Step 4 are only as good as the patterns identified here.

## Step 4 — Generate recommendations

Based on the patterns from Step 3, produce:

1. **Top 3 things that worked** — be specific (e.g. "campaigns targeting DeFi products with 3 generated posts averaged 8.2 points/credit")
2. **Top 2 things to stop doing** — be specific (e.g. "campaigns with > 5 posts showed diminishing returns below 3 points/credit")
3. **Next campaign strategy** — a concrete plan: what product category to target, how many posts to generate, what keyword angle to take, estimated credit cost and expected ROI based on historical data

## Output format

Produce this report after completing all four steps:

```
CAMPAIGN PERFORMANCE REPORT
═══════════════════════════════════════════════════
Agent:            [agent name or "Manual data"]
Period:           [date range or "All campaigns"]
Campaigns:        [number analysed]
Data source:      [API + manual points / Manual]
───────────────────────────────────────────────────
OVERVIEW
  Total credits spent:    [X]
  Total points earned:    [X]
  Total $PRO earned:      [X or "N/A"]
  Overall ROI:            [X points per credit]
  Overall rating:         [🟢 Excellent / 🟡 Good / 🟠 Average / 🔴 Poor]
───────────────────────────────────────────────────
CAMPAIGN RANKINGS
  #1  [Campaign name]   ROI: [X pts/credit]  🟢/🟡/🟠/🔴
  #2  [Campaign name]   ROI: [X pts/credit]  🟢/🟡/🟠/🔴
  ... (all campaigns)
───────────────────────────────────────────────────
TOP PERFORMER
  Campaign:    [name]
  ROI:         [X points per credit]
  Credits:     [spent]
  Points:      [earned]
  What worked: [specific insight]

WORST PERFORMER
  Campaign:    [name]
  ROI:         [X points per credit]
  Credits:     [spent]
  Points:      [earned]
  What failed: [specific insight]
───────────────────────────────────────────────────
PATTERNS IDENTIFIED
  Keywords:    [finding]
  Content:     [finding]
  Post volume: [finding]
  Timing:      [finding or "Insufficient data"]
───────────────────────────────────────────────────
RECOMMENDATIONS
  ✅ Keep doing:
     1. [specific]
     2. [specific]
     3. [specific]

  ❌ Stop doing:
     1. [specific]
     2. [specific]

  🎯 Next campaign strategy:
     Target:            [product category / keyword angle]
     Posts to generate: [number]
     Estimated cost:    [X credits]
     Expected ROI:      [X–Y points/credit based on history]
═══════════════════════════════════════════════════
```

## Reference files

- `references/METRICS.md` — what each metric means and how to interpret edge cases
- `references/API_REFERENCE.md` — ProductClank API endpoints for campaign data, including what is and is not available
- `scripts/fetch-data.sh` — complete data pull script with pagination
