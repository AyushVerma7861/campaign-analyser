#!/usr/bin/env bash
# fetch-data.sh — Pull campaign structure from ProductClank API
#
# Usage: PRODUCTCLANK_API_KEY=your_key ./scripts/fetch-data.sh
#
# What this script fetches:
#   - Credit balance
#   - All campaigns (names, keywords, dates, post counts)
#
# What it cannot fetch (not yet in API):
#   - Points earned per campaign
#   - $PRO earned per campaign
#
# After running this script, paste the output into the agent chat.
# The agent will ask you to fill in points and $PRO for each campaign,
# then calculate ROI automatically.

set -euo pipefail

API_BASE="https://api.productclank.com/api/v1"
KEY="${PRODUCTCLANK_API_KEY:-}"

if [[ -z "$KEY" ]]; then
  echo "ERROR: PRODUCTCLANK_API_KEY is not set."
  echo "Usage: PRODUCTCLANK_API_KEY=your_key ./scripts/fetch-data.sh"
  echo ""
  echo "No API key? Use manual mode instead — paste your campaign data"
  echo "directly into the agent chat. See QUICKSTART.md for sample data."
  exit 1
fi

AUTH_HEADER="Authorization: Bearer $KEY"

echo "=== CREDIT BALANCE ==="
BALANCE=$(curl -sf "$API_BASE/agents/credits/balance" -H "$AUTH_HEADER") || {
  echo "ERROR: Could not reach API. Check your key and network."
  exit 1
}

# Check for API error
if echo "$BALANCE" | jq -e '.success == false' > /dev/null 2>&1; then
  echo "API error: $(echo "$BALANCE" | jq -r '.message // .error // "unknown error"')"
  exit 1
fi

echo "$BALANCE" | jq '{
  balance,
  plan,
  lifetime_purchased,
  lifetime_used
}'

echo ""
echo "=== FETCHING ALL CAMPAIGNS ==="

ALL_CAMPAIGNS="[]"
OFFSET=0
LIMIT=20

while true; do
  RESPONSE=$(curl -sf "$API_BASE/agents/campaigns?limit=$LIMIT&offset=$OFFSET" \
    -H "$AUTH_HEADER") || {
    echo "ERROR fetching campaigns at offset $OFFSET"
    break
  }

  TOTAL=$(echo "$RESPONSE" | jq -r '.total // 0')
  BATCH=$(echo "$RESPONSE" | jq '.campaigns // []')
  BATCH_COUNT=$(echo "$BATCH" | jq 'length')

  ALL_CAMPAIGNS=$(echo "[$ALL_CAMPAIGNS, $BATCH]" | jq 'add')

  echo "Fetched $BATCH_COUNT campaigns (offset $OFFSET, total $TOTAL)..." >&2

  if (( OFFSET + LIMIT >= TOTAL )); then
    break
  fi
  OFFSET=$(( OFFSET + LIMIT ))
done

TOTAL_FETCHED=$(echo "$ALL_CAMPAIGNS" | jq 'length')
echo "Total campaigns fetched: $TOTAL_FETCHED"
echo ""

echo "=== FETCHING POST COUNTS ==="
echo "Fetching stats for each campaign (this may take a moment)..."
echo ""

# For each campaign, fetch detail to get stats.total_posts
CAMPAIGNS_WITH_STATS="[]"

while IFS= read -r CAMPAIGN_ID; do
  DETAIL=$(curl -sf "$API_BASE/agents/campaigns/$CAMPAIGN_ID" \
    -H "$AUTH_HEADER" 2>/dev/null) || continue

  ENTRY=$(echo "$DETAIL" | jq '.campaign | {
    id,
    title,
    keywords,
    status,
    created_at,
    posts_generated: (.stats.total_posts // 0),
    replies_total: (.stats.total_replies // 0),
    replies_claimed: (.stats.claimed_replies // 0),
    replies_submitted: (.stats.submitted_replies // 0),
    credits_spent: (10 + ((.stats.total_posts // 0) * 12))
  }')

  CAMPAIGNS_WITH_STATS=$(echo "[$CAMPAIGNS_WITH_STATS, [$ENTRY]]" | jq 'add')
done < <(echo "$ALL_CAMPAIGNS" | jq -r '.[].id')

echo ""
echo "=== CAMPAIGN STRUCTURE ==="
echo "$CAMPAIGNS_WITH_STATS" | jq '.'

echo ""
echo "=== NEXT STEP ==="
echo "Paste the output above into the agent chat."
echo ""
echo "The agent will ask you to provide for each campaign:"
echo "  - Points earned (check app.productclank.com for your leaderboard points)"
echo "  - \$PRO earned (check your wallet or the S6 rewards page)"
echo ""
echo "Once you provide those values, the agent will calculate full ROI."
