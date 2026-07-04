# Quickstart — campaign-analyser

Get your first campaign analysis in under 5 minutes.

## Option A — With a ProductClank API key

Run the fetch script to pull all your campaign data automatically:

```bash
chmod +x scripts/fetch-data.sh
PRODUCTCLANK_API_KEY=your_key_here ./scripts/fetch-data.sh
```

Copy the output, paste it into the agent chat, and say:

> "Analyse this campaign data and give me a full performance report."

## Option B — Without an API key (manual mode)

You can test the skill right now using the sample data below. Paste this into the agent chat:

> "Analyse my ProductClank campaign performance using this data:"

```
Campaign: DeFi Yield Aggregator Launch
Product/Keywords: yield farming, APY, DeFi, Base chain
Posts generated: 3
Points earned: 187
$PRO earned: 0.42
Date: June 2026

Campaign: AI Agent Tools Promo
Product/Keywords: AI agents, autonomous, agent economy
Posts generated: 5
Points earned: 203
$PRO earned: 0.51
Date: June 2026

Campaign: NFT Marketplace Feature Drop
Product/Keywords: NFT, digital collectibles, Base NFT
Posts generated: 2
Points earned: 44
$PRO earned: 0.09
Date: June 2026

Campaign: Superfluid Streaming Payroll
Product/Keywords: Superfluid, token streaming, payroll, real-time payments
Posts generated: 4
Points earned: 312
$PRO earned: 0.78
Date: July 2026

Campaign: Web3 Gaming Ecosystem
Product/Keywords: blockchain gaming, play-to-earn, Base gaming
Posts generated: 6
Points earned: 198
$PRO earned: 0.44
Date: July 2026
```

## What to expect

The agent will:
1. Calculate ROI for each campaign
2. Rank them from best to worst
3. Identify keyword and content patterns
4. Give you 3 things to keep doing, 2 to stop doing
5. Propose a concrete next campaign strategy

## Loading the skill in VS Code

1. Make sure `.agents/skills/campaign-analyser/SKILL.md` exists in your open folder
2. Open Copilot Chat → switch to **Agent** mode
3. Type `/skills` — you should see `campaign-analyser` in the list
4. Paste the sample data above and ask for an analysis
