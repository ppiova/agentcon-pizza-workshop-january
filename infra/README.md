# Infra (Azure)

This folder provisions the **Azure Static Web App** used to host the VitePress site.

## Option A (fully automates RG creation) — Subscription-scope deploy

This creates (or reuses) the Resource Group and deploys the Static Web App inside it.

```bash
az login --use-device-code

az deployment sub create \
  -l westus \
  -f infra/subscription.bicep \
  -p resourceGroupName=rg-agentcon-pizza-workshop-january
```

Outputs include:
- `staticSiteUrl`
- `deploymentToken` (use this as the GitHub Actions secret value)

## Option B (RG already exists) — Resource-group scope deploy

```bash
az login --use-device-code

az group create -n rg-agentcon-pizza-workshop-january -l westus

az deployment group create \
  -g rg-agentcon-pizza-workshop-january \
  -f infra/main.bicep
```

## About automating `az login`

- **Interactive login (device code)** is the simplest, but requires a human.
- **Fully automated** deployments require non-interactive credentials (recommended: GitHub Actions OIDC via `azure/login`).

This repo still needs the Static Web Apps **deployment token** in GitHub as `AZURE_STATIC_WEB_APPS_API_TOKEN` for the `Azure/static-web-apps-deploy@v1` action.
