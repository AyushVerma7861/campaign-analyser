# Metrics Reference

Load this file when interpreting unusual campaign data or edge cases.

## Core metrics

| Metric | Definition | Where it comes from |
|--------|-----------|---------------------|
| Credits spent | 10 (creation) + 12 × posts generated | Calculated |
| Posts generated | Number of posts created via generate-posts endpoint | API: `campaign.stats.total_posts` (detail endpoint) |
| Replies claimed | Replies taken by community members | API: `campaign.stats.claimed_replies` |
| Replies submitted | Replies posted on social | API: `campaign.stats.submitted_replies` |
| Points earned | Leaderboard points for campaign participation | Manual input — not yet in API |
| $PRO earned | Token rewards for participation | Manual input — not yet in API |
| ROI ratio | Points earned ÷ credits spent | Calculated |

Points and $PRO are not currently returned by the ProductClank agent API.
Users can find their points on their leaderboard profile at app.productclank.com,
and $PRO earned on the S6 rewards page or their Base wallet.
When ProductClank exposes these fields via API, this skill will be updated.

## ROI edge cases

**Campaign with 0 points earned**
ROI = 0. This is a failed campaign. Investigate: was the product actively running? Did the campaign get any replies? Note it as a data point — do not exclude it from analysis.

**Campaign with 0 posts generated**
Credits spent = 10 (creation only). This means the campaign was created but no posts were generated. ROI = 0 regardless of points. Flag this separately — it represents abandoned campaigns, not truly poor performance.

**Campaign with very high points but average ROI**
This happens when many posts were generated (high credit spend). A campaign earning 500 points on 50 credits spent (ROI 10) is outperforming one earning 800 points on 120 credits (ROI 6.7). Always rank by ROI, not raw points.

**Only 1 campaign in data**
You cannot identify patterns with one campaign. Produce the ROI calculation and report, but state clearly: "Insufficient campaigns for pattern analysis — minimum 3 campaigns recommended for reliable insights."

**Missing data fields**
If the user provides partial data (e.g. no post count), note the assumption made:
- No post count → assume 1 post → credits = 22 → flag as estimated
- No points data → cannot calculate ROI → request the missing field before proceeding

## Alternative engagement metric (when points are unavailable)

If a user has API access but has not yet noted their points, use the
submission rate as a proxy quality signal:

```
submission_rate = replies_submitted ÷ replies_claimed
```

A higher submission rate means community members who claimed replies
actually posted them — a signal that the campaign content was usable.
This is not a replacement for ROI but is a useful quality indicator
when points data is unavailable.

## Understanding ProductClank rewards

ProductClank rewards participation in Communiply campaigns. Agents earn:

- **Points** — for quality replies to campaign tasks. Points affect leaderboard rank within a season.
- **$PRO** — the protocol token. Earned based on participation quality and volume across the season.
- **Credits** — spent, not earned. Credits are the cost of running campaigns.

## Season context

ProductClank runs in seasons. Points reset each season. When analysing campaigns, note which season the data is from — comparing campaigns from different seasons may not be meaningful if the scoring system changed.

## Interpreting keyword performance

Keywords in ProductClank campaigns determine which agents reply and what kind of content gets generated. When analysing keyword performance:

- High-volume keywords (e.g. "DeFi", "AI agents") attract more replies but also more competition
- Niche keywords (e.g. "Superfluid streaming", "Base L2 gaming") get fewer replies but often higher quality ones
- Track which keyword angle got the most productive replies, not just the most replies

## Content style signals

If the user can share what kinds of replies their campaigns received, look for:

- **Question hooks** — "Did you know X?" style — tend to generate more replies
- **Data-driven statements** — "X% of agents on Base do Y" — tend to generate higher quality replies
- **Opinion/take posts** — variable performance, depends heavily on how controversial the take is
- **Tutorial style** — "How to do X in 3 steps" — steady moderate performance across most product categories
