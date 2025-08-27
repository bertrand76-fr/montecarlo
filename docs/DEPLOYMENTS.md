# 🚀 Guide de déploiement Monte Carlo Platform

## Vue d'ensemble

Ce guide couvre le déploiement complet de la plateforme Monte Carlo sur Azure via Azure DevOps Pipelines.

## 📋 Prérequis

### Infrastructure Azure
- **Azure Subscription** active avec droits Contributor
- **Resource Group** pour Terraform state : `rg-terraform-state`
- **Storage Account** pour state : `sttfstatedev`

### Outils requis
- **Azure CLI** >= 2.50.0
- **Terraform** >= 1.6.0 (installé par pipeline)
- **Git** pour repository management

### Accès
- **Azure DevOps** organization avec droits admin projet
- **GitHub** repository access (lecture/écriture)

## 🏗️ Architecture de déploiement

```
┌─────────────────┐    ┌──────────────────┐    ┌─────────────────────┐
│   GitHub Repo   │    │  Azure DevOps    │    │    Azure Cloud      │
│                 │    │    Pipeline      │    │                     │
│ ├── terraform/  │───▶│ Stage 1: CI      │───▶│ Resource Group      │
│ ├── src/        │    │ ├── Plan         │    │ ├── Function App    │
│ ├── docs/       │    │ └── Build        │    │ ├── App Insights    │
│ └── pipeline.yml│    │                  │    │ └── [Future: SB,    │
└─────────────────┘    │ Stage 2: Infra   │    │     Storage, etc.]  │
                       │ ├── Cleanup      │    │                     │
                       │ └── Deploy       │    └─────────────────────┘
                       │                  │
                       │ Stage 3: Apps    │
                       │ └── Function     │
                       └──────────────────┘
```

## 🚀 Setup initial

### Étape 1 : Terraform State Storage

```bash
# Créer infrastructure pour state Terraform (one-time setup)
az login
az group create --name rg-terraform-state --location "France Central"
az storage account create \
  --name sttfstatedev \
  --resource-group rg-terraform-state \
  --location "France Central" \
  --sku Standard_LRS
az storage container create \
  --name tfstate \
  --account-name sttfstatedev
```

### Étape 2 : Service Principal

```bash
# Créer service principal pour Azure DevOps
az ad sp create-for-rbac \
  --name "montecarlo-devops" \
  --role contributor \
  --scopes /subscriptions/YOUR_SUBSCRIPTION_ID

# Output à noter :
# {
#   "appId": "client-id",
#   "password": "client-secret", 
#   "tenant": "tenant-id"
# }
```

### Étape 3 : Azure DevOps Project

```bash
# Via interface web dev.azure.com
1. Nouvelle organization (si nécessaire)
2. Nouveau projet "montecarlo"
3. Settings → Repos → Import repository
   - URL: https://github.com/YOUR_USERNAME/montecarlo.git
```

## 🔧 Configuration Azure DevOps

### Service Connection

```
Project Settings → Service connections → New
├── Type: Azure Resource Manager
├── Authentication: Service principal (manual)
├── Name: montecarlo-service-connection
├── Subscription ID: YOUR_SUBSCRIPTION_ID
├── Client ID: [from service principal]
├── Client Secret: [from service principal]
└── Tenant ID: YOUR_TENANT_ID
```

### Variable Group

```
Pipelines → Library → Variable groups → New
├── Name: montecarlo-variables
├── Variables:
│   ├── RG_MONTECARLO = "rg-montecarlo-demo"
│   ├── ARM_SUBSCRIPTION_ID = "YOUR_SUBSCRIPTION_ID" (secret)
│   └── ARM_TENANT_ID = "YOUR_TENANT_ID" (secret)
└── Security: Allow access to all pipelines ✓
```

### Environment

```
Pipelines → Environments → New environment
├── Name: montecarlo-dev
├── Type: None
└── Security: Auto-approve (dev environment)
```

## 📦 Déploiement

### Déploiement automatique

1. **Push vers develop branch**
   ```bash
   git add .
   git commit -m "Deploy ÉTAPE 1 - Resource Group"
   git push origin develop
   ```

2. **Pipeline auto-triggered**
   - Stage 1: CI Build (Terraform Plan + Function Build)
   - Stage 2: Infrastructure Deploy (Cleanup + Deploy)
   - Stage 3: Application Deploy (Function deployment + health check)

### Déploiement manuel

```bash
# Via Azure DevOps interface
Pipelines → montecarlo-pipeline → Run pipeline
├── Branch: develop (ou main)
├── Variables: (defaults from Variable Group)
└── Run
```

## 🧪 Validation post-déploiement

### Tests automatiques (pipeline)

Le pipeline exécute automatiquement :
```powershell
# Health check
Invoke-RestMethod -Uri "$functionUrl/api/health"

# Expected response:
{
  "status": "healthy",
  "timestamp": "2025-01-XX...",
  "version": "1.0.0-minimal"
}
```

### Tests manuels

```bash
# Récupérer Function URL depuis outputs Terraform
FUNCTION_URL=$(terraform output -raw producer_function_url)

# Test health
curl $FUNCTION_URL/api/health

# Test configuration
curl $FUNCTION_URL/api/status

# Test fonctionnel (génération Monte Carlo)
curl -X POST $FUNCTION_URL/api/start \
  -H "Content-Type: application/json" \
  -d '{"duration": 1, "override_rate": 10}'

# Expected response:
{
  "status": "completed",
  "total_points_generated": 10,
  "pi_estimate": 3.xxxx,
  "sample_points": [...]
}
```

## 📊 Monitoring déploiement

### Azure Portal

```
Resources déployés visibles dans:
├── Resource Group: rg-montecarlo-demo
├── Function App: func-producer-montecarlo-xxx
├── App Service Plan: plan-montecarlo-xxx
└── Application Insights: appi-montecarlo-xxx
```

### Logs et diagnostics

```bash
# Logs Function App
az functionapp log tail --name FUNCTION_NAME --resource-group RG_NAME

# Metrics Application Insights
az monitor app-insights query \
  --app APPLICATION_INSIGHTS_NAME \
  --analytics-query "requests | limit 10"
```

## 🔧 Troubleshooting

### Erreurs communes

#### 1. Terraform Backend Access
```
Error: Failed to get existing workspaces

Solution:
- Vérifier Storage Account existe
- Vérifier permissions Service Principal
- Vérifier container "tfstate" existe
```

#### 2. Function Deployment Failed
```
Error: Function deployment timeout

Solution:
- Vérifier package.zip taille < 100MB
- Vérifier requirements.txt valid
- Check App Service Plan capacity
```

#### 3. Health Check Failed
```
Error: Function not responding

Solution:
- Wait 60 seconds after deployment
- Check Function App logs
- Verify Application Settings
```

### Logs utiles

```bash
# Pipeline logs
Azure DevOps → Pipelines → Run → Logs

# Function logs  
Azure Portal → Function App → Monitor → Log Stream

# Terraform logs
Pipeline → Infrastructure Deploy → Task logs
```

## 🧹 Cleanup

### Automatique (par design)
Le pipeline **détruit automatiquement** toute l'infrastructure à chaque run :
- Cleanup systématique du Resource Group
- Redéploiement infrastructure propre
- Pas d'accumulation de ressources

### Manuel (si nécessaire)
```bash
# Destroy complet via Terraform
terraform destroy -var="resource_group_name=rg-montecarlo-demo"

# Ou via Azure CLI
az group delete --name rg-montecarlo-demo --yes
```

## 🎯 Évolution déploiement

### ÉTAPE 2 - Service Bus + Consumers
```yaml
# Modification variables pipeline
enable_consumer: true
enable_servicebus: true

# Nouveaux modules Terraform
├── modules/servicebus/
├── modules/consumer/
└── modules/storage/
```

### ÉTAPE 3 - Interface + Monitoring
```yaml
# Ajout components
enable_streamlit: true
enable_grafana: true

# Dashboard deployment
├── grafana/dashboards/
└── streamlit/app.py
```

## 📈 Métriques déploiement

### Performance pipeline
- **Build time** : ~3-5 minutes
- **Deploy time** : ~8-12 minutes  
- **Total time** : ~15 minutes end-to-end

### Coûts infrastructure
- **ÉTAPE 1** : ~€1-3/mois (Function App + App Insights)
- **ÉTAPE 2** : ~€15-25/mois (+ Service Bus + Container Instances)
- **ÉTAPE 3** : ~€20-35/mois (+ App Service pour Streamlit)

---

*Guide maintenu à jour avec l'évolution de la plateforme. Version actuelle : ÉTAPE 1 - Infrastructure minimale*