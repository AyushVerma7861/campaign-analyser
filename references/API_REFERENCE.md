# ProductClank API Reference

Load this file when making API calls or debugging API responses.

## Base URL

```
https://api.productclank.com/api/v1
```

All requests must include:
```
Authorization: Bearer $PRODUCTCLANK_API_KEY
Content-Type: application/json
```

Never call `app.productclank.com` — that is the web UI. Agent API calls go to `api.productclank.com` only.

## What the API currently exposes (and what it does not)

| Data | Available via API | How to get it |
|------|------------------|---------------|
| Campaign names and keywords | ✅ Yes | `GET /agents/campaigns` |
| Post counts per campaign | ✅ Yes | `GET /agents/campaigns/{id}` → `stats.total_posts` |
| Reply stats per campaign | ✅ Yes | `GET /agents/campaigns/{id}` → `stats` |
| Credit balance | ✅ Yes | `GET /agents/credits/balance` |
| Points earned per campaign | ❌ Not yet | Manual input required |
| $PRO earned per campaign | ❌ Not yet | Manual input required |
| Overall agent points total | ❌ Not yet | Manual input required |

Points and $PRO data are not yet exposed through the agent API. When ProductClank adds these fields, this skill will be updated to fetch them automatically. See README.md for planned future capabilities.

## Endpoints used by campaign-analyser

### Get credit balance
```bash
GET /agents/credits/balance
```
Returns current credit balance.

```bash
curl -s https://api.productclank.com/api/v1/agents/credits/balance \
  -H "Authorization: Bearer $PRODUCTCLANK_API_KEY" | jq .
```

Response:
```json
{
  "success": true,
  "balance": 1200,
  "plan": "free",
  "lifetime_purchased": 1000,
  "lifetime_used": 100,
  "lifetime_bonus": 300
}
```

### Get campaigns list
```bash
GET /agents/campaigns
```
Returns list of campaigns created by this agent. Paginated — use `limit` and `offset`.

```bash
curl -s "https://api.productclank.com/api/v1/agents/campaigns?limit=20&offset=0" \
  -H "Authorization: Bearer $PRODUCTCLANK_API_KEY" | jq .
```

Response:
```json
{
  "success": true,
  "campaigns": [
    {
      "id": "uuid",
      "campaign_number": "CP-042",
      "title": "My Campaign",
      "status": "active",
      "keywords": ["AI tools", "productivity"],
      "created_at": "2026-03-10T12:00:00Z",
      "url": "https://app.productclank.com/communiply/uuid"
    }
  ],
  "total": 5,
  "limit": 20,
  "offset": 0
}
```

Note: the list endpoint does not include post counts or reply stats. Fetch each campaign individually for those.

### Get single campaign details
```bash
GET /agents/campaigns/{campaign_id}
```
Returns full campaign details including post and reply stats.

```bash
curl -s https://api.productclank.com/api/v1/agents/campaigns/CAMPAIGN_ID \
  -H "Authorization: Bearer $PRODUCTCLANK_API_KEY" | jq .
```

Response:
```json
{
  "success": true,
  "campaign": {
    "id": "uuid",
    "title": "My Campaign",
    "status": "active",
    "keywords": ["AI tools"],
    "search_context": "People discussing AI tools",
    "reply_guidelines": "...",
    "min_follower_count": 100,
    "created_at": "2026-03-10T12:00:00Z",
    "stats": {
      "total_posts": 15,
      "total_replies": 15,
      "claimed_replies": 3,
      "submitted_replies": 1
    }
  }
}
```

Key field for post count: `campaign.stats.total_posts`
There is no `points` or `posts_count` field — those do not exist in this response.

## Pagination

The campaigns list uses offset-based pagination, not cursor-based.

```bash
# Page 1
curl -s "https://api.productclank.com/api/v1/agents/campaigns?limit=20&offset=0" \
  -H "Authorization: Bearer $PRODUCTCLANK_API_KEY" | jq .

# Page 2
curl -s "https://api.productclank.com/api/v1/agents/campaigns?limit=20&offset=20" \
  -H "Authorization: Bearer $PRODUCTCLANK_API_KEY" | jq .
```

Continue fetching while `offset + limit < total`. Collect all campaigns before running analysis.

## Common API errors

| Status | Meaning | Action |
|--------|---------|--------|
| 401 | Invalid or expired API key | Ask user to check their key |
| 403 | Agent not registered | Direct user to register at app.productclank.com/agents |
| 404 | Campaign not found | Campaign ID may be wrong — list campaigns first |
| 429 | Rate limited | Wait 60 seconds then retry |
| 500 | Server error | Retry once; if it persists, switch to manual mode |

## Manual mode data format

When the user cannot provide an API key, ask them to provide data in this format:

```
Campaign: [name]
Product/Keywords: [what was promoted]
Posts generated: [number]
Points earned: [number]
$PRO earned: [amount or "unknown"]
Date: [approximate date or season]
```

Accept any reasonable format — extract the values flexibly rather than requiring strict formatting.
