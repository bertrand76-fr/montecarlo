# 🏗️ Architecture Monte Carlo Platform

## Vue d'ensemble

La **Monte Carlo Platform** est une solution de calcul distribué cloud-native démontrant les patterns modernes d'auto-scaling, monitoring et infrastructure as code.

## 🎯 Objectifs architecturaux

- **Scalabilité automatique** : 1→5 consumers selon charge
- **Cost-awareness** : Optimisation coûts par monitoring temps réel  
- **Observabilité** : Monitoring production-grade
- **Infrastructure jetable** : Destroy/recreate à chaque déploiement
- **Pragmatisme technique** : Choix technologiques justifiés vs hype

## 🏛️ Architecture cible (finale)

```
┌─────────────────┐    ┌──────────────────┐    ┌─────────────────────┐
│   Producer      │    │   Service Bus    │    │   Auto-scaling      │
│ (Azure Function)│───▶│     Queue        │───▶│   Consumers         │
│                 │    │                  │    │ (Container Instance)│
└─────────────────┘    └──────────────────┘    └─────────────────────┘
         │                       │                         │
         ▼                       ▼                         ▼
┌─────────────────┐    ┌──────────────────┐    ┌─────────────────────┐
│ App Insights    │    │ Scaling Rules    │    │   Table Storage     │
│   (Metrics)     │    │  (Queue Depth)   │    │   (Results)         │
└─────────────────┘    └──────────────────┘    └─────────────────────┘
         │                                               │
         └────────────────── Monitoring ─────────────────┘
                              │
                    ┌──────────────────┐
                    │ Grafana Cloud    │
                    │   Dashboards     │
                    └──────────────────┘
                              │
                    ┌──────────────────┐
                    │ Streamlit UI     │
                    │   (Control)      │
                    └──────────────────┘
```

## 📋 État actuel (ÉTAPE 1)

### ✅ Implémenté
- **Infrastructure Terraform** : Resource Group + base
- **Producer Function** : Génération points Monte Carlo
- **Pipeline CI/CD** : Azure DevOps avec cleanup automatique
- **Monitoring basique** : Application Insights + health checks

### 🚧 En cours de développement

#### ÉTAPE 2 - Messaging & Storage
- **Service Bus** : Queue pour distribution messages
- **Table Storage** : Stockage résultats calculs
- **Consumer** : Container Instances avec auto-scaling
- **Metrics custom** : Prometheus integration

#### ÉTAPE 3 - Interface & Monitoring
- **Streamlit Interface** : Contrôle manuel producer
- **Grafana Dashboards** : Monitoring professionnel
- **Cost tracking** : Métriques €/million points

## 🧮 Algorithme Monte Carlo

### Principe mathématique
```
Estimation π par échantillonnage aléatoire:
1. Générer points (x,y) dans carré [0,1]×[0,1]
2. Tester si x² + y² ≤ 1 (dans cercle unité)
3. Ratio points_dans_cercle/total ≈ π/4
4. π ≈ 4 × ratio
```

### Flow de données
```
Producer → (x,y) → Queue → Consumer → (x,y,inCircle) → Storage
                                ↓
                           Aggregation → π estimate
```

## 🏗️ Choix architecturaux

### Container Instances vs Kubernetes
**Décision** : Container Instances (ÉTAPE 1-2), K8s documenté

**Justification** :
- **Simplicité** : Pas de cluster management overhead
- **Cost** : Pay-per-second, pas de nodes permanents
- **Scaling** : Azure-managed auto-scaling suffisant
- **Time-to-market** : Setup 10x plus rapide

**Conditions migration K8s** :
- Workloads permanents (>8h/jour)
- Multi-tenancy requirements
- Complex networking needs
- Team K8s expertise disponible

### Service Bus vs Apache Kafka
**Décision** : Service Bus

**Justification** :
- **Managed service** : Pas d'infrastructure à maintenir
- **Azure integration** : Scaling rules natives
- **Volume adapté** : <1M messages/jour = Service Bus sweet spot
- **Complexity** : Kafka overkill pour use case

**Seuil Kafka** : >10M messages/jour ou streaming real-time

### Table Storage vs Azure SQL
**Décision** : Table Storage

**Justification** :
- **Schema-less** : Structure JSON flexible
- **Performance** : Write-heavy workload optimisé
- **Cost** : ~€0.50/mois vs €15/mois SQL
- **Scalability** : Horizontal par design

## 📊 Patterns d'auto-scaling

### Scaling Rules
```yaml
Scale Up Condition:
  - Queue depth > 100 messages
  - CPU > 70% for 2 minutes
  - Response time > 5 seconds

Scale Down Condition:
  - Queue depth < 10 messages
  - CPU < 30% for 5 minutes
  - No active processing for 10 minutes

Limits:
  - Min instances: 1
  - Max instances: 5
  - Scale increment: +1 instance
  - Cooldown: 2 minutes
```

### Cost Optimization
- **Spot instances** pour consumers (quand disponible)
- **Schedule-based scaling** pour patterns prévisibles  
- **Metrics alerting** si coût >€50/mois
- **Auto-shutdown** si inactif >30 minutes

## 🔧 Infrastructure as Code

### Modules Terraform
```
terraform/
├── main.tf              # Orchestration
├── variables.tf         # Configuration
├── outputs.tf          # Intégration pipeline
└── modules/            # (ÉTAPE 2)
    ├── storage/        # Table Storage + config
    ├── servicebus/     # Queue + scaling rules  
    ├── producer/       # Function App + settings
    ├── consumer/       # Container Instances + scaling
    ├── monitoring/     # App Insights + Grafana
    └── streamlit/      # Interface web
```

### Pipeline Strategy
- **Always destroy** : Infrastructure jetable
- **3-stage pipeline** : CI → Infrastructure → Application
- **Parallel builds** : Terraform plan + App build
- **Health validation** : Post-deployment testing

## 📈 Observabilité

### Metrics Key Performance Indicators
- **Processing Rate** : points/seconde
- **Pi Accuracy** : |π_estimated - π_real|
- **Cost Efficiency** : €/million points
- **Scaling Events** : up/down frequency
- **Queue Health** : depth + processing time

### Dashboards (ÉTAPE 3)
1. **Platform Overview** : Health + throughput + costs
2. **Algorithm Quality** : Convergence + accuracy trends  
3. **Infrastructure** : Scaling events + resource usage
4. **Business** : Cost trends + ROI metrics

## 🔮 Évolution future

### Phase 4 - Enterprise Features
- **Multi-tenant** : Support plusieurs algorithmes
- **RBAC** : Role-based access control
- **Audit logging** : Compliance requirements
- **Disaster recovery** : Multi-region deployment

### Phase 5 - Advanced Algorithms  
- **GPU acceleration** : Azure Container Instances GPU
- **ML integration** : Adaptive scaling via ML models
- **Batch processing** : Large-scale computation jobs
- **Real-time streaming** : Event-driven architecture

---

*Architecture évolutive conçue pour démontrer expertise cloud/DevOps tout en restant pragmatique et cost-effective.*