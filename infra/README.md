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

## Option C (no local console) — GitHub Actions (OIDC)

This repo includes a workflow that can provision Azure + deploy the site **without** creating a permanent SWA token secret:

- Workflow: `.github/workflows/azure-provision-and-deploy.yml`

One-time setup:
1) Create an Entra ID App Registration (service principal)
2) Configure GitHub Actions OIDC (federated credentials) for your repo
3) Grant the service principal permissions in Azure (at least Contributor on the subscription or target RG)
4) Add these **Repository Variables** in GitHub:
  - `AZURE_CLIENT_ID`
  - `AZURE_TENANT_ID`
  - `AZURE_SUBSCRIPTION_ID`

After that:
- GitHub -> Actions -> “Provision + Deploy (Azure Static Web Apps)” -> Run workflow

This workflow provisions the SWA via Bicep, fetches the SWA deployment token via ARM `listSecrets`, then runs `Azure/static-web-apps-deploy@v1`.

This repo still needs the Static Web Apps **deployment token** in GitHub as `AZURE_STATIC_WEB_APPS_API_TOKEN` for the `Azure/static-web-apps-deploy@v1` action.
