# Infra (Azure)

This repo is set up as an **Azure Developer CLI** (`azd`) template.

Running `azd up` will:
1) Provision an **Azure Static Web App**
2) Build the VitePress site (`npm run build`)
3) Deploy the built static site

## Prerequisites

- Install the Azure Developer CLI: https://learn.microsoft.com/azure/developer/azure-developer-cli/install-azd
- An Azure subscription you can deploy into

## Deploy

From the repo root:

```bash
azd up
```

Follow the prompts to pick:
- Subscription
- Resource group
- Location (default in Bicep is `westus`)
