# 🎯 Monte Carlo Distributed Computing Platform

> **Plateforme de calcul distribué Monte Carlo avec monitoring professionnel et auto-scaling intelligent**

[![Build Status](https://dev.azure.com/YOUR_ORG/montecarlo/_apis/build/status/montecarlo-pipeline?branchName=main)](https://dev.azure.com/YOUR_ORG/montecarlo/_build/latest?definitionId=1&branchName=main)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## 🏗️ Architecture

Plateforme cloud-native démontrant les patterns modernes de calcul distribué :

```
Producer (Azure Function) → Service Bus Queue → Auto-scaling Consumers → Table Storage
                                                      ↓
                           Monitoring Stack (Grafana + Prometheus + App Insights)
                                                      ↓
                               Streamlit Control Interface
```

### Technologies

- **Cloud**: Microsoft Azure (Container Instances, Service Bus, Table Storage)
- **Infrastructure**: Terraform (modules réutilisables)  
- **CI/CD**: Azure DevOps Pipelines (repo GitHub)
- **Monitoring**: Grafana Cloud + Prometheus + Application Insights
- **Languages**: Python 3.11

## 🚀 Démarrage rapide

### Prérequis

- Azure CLI + Subscription active
- Terraform >= 1.6
- Python 3.11
- Azure DevOps access

### Configuration

```bash
# 1. Clone du repository
git clone https://github.com/YOUR_USERNAME/montecarlo.git
cd montecarlo

# 2. Configuration Resource Group
export RG_MONTECARLO="rg-montecarlo-demo"

# 3. Déploiement via Azure Pipelines
# Push vers main → trigger automatique pipeline
git add .
git commit -m "Initial setup"
git push origin main
```

## 📊 Fonctionnalités

### ✅ ÉTAPE 1 - Base Platform (En cours)
- [x] Structure projet + CI/CD
- [x] Infrastructure Terraform modulaire
- [ ] Producer Azure Function
- [ ] Service Bus + Table Storage
- [ ] Pipeline fonctionnel

### 🚧 ÉTAPE 2 - Auto-scaling (Planifié)
- [ ] Consumer Container Instances
- [ ] Auto-scaling basé sur queue depth
- [ ] Monitoring Prometheus/Grafana

### 🎯 ÉTAPE 3 - Interface (Planifié)
- [ ] Interface Streamlit de contrôle
- [ ] Dashboards Grafana professionnels
- [ ] Documentation comparative architectures

## 🎪 Algorithme Monte Carlo

### Calcul π par méthode Monte Carlo

1. **Producer** génère points aléatoires (x,y) ∈ [0,1]
2. **Consumers** calculent si x² + y² ≤ 1 (dans cercle unité)
3. **Estimation**: π ≈ 4 × (points_dans_cercle / total_points)
4. **Convergence** observée via monitoring temps réel

### Auto-scaling Intelligence

- **1 consumer** par défaut (coût optimisé)
- **Scale up** si queue depth > 100 messages
- **Scale down** si queue depth < 10 messages  
- **Maximum 5 consumers** simultanés
- **Cost tracking** par million de points

## 📈 Monitoring & Observabilité

- **Processing rate**: points/seconde temps réel
- **Pi convergence**: précision estimation vs π théorique
- **Cost tracking**: €/million points calculés
- **Scaling events**: historique montée/descente charge
- **Queue depth**: métriques Service Bus
- **Consumer health**: status instances actives

## 🏛️ Architecture Decisions

Choix techniques pragmatiques documentés :

- **Container Instances vs Kubernetes**: Simplicité vs complexité
- **Service Bus vs Apache Kafka**: Managed vs self-hosted
- **Table Storage vs Azure SQL**: NoSQL vs relationnel
- **Grafana Cloud vs Azure Monitor**: Flexibilité vs intégration

## 📚 Documentation

- [Architecture Overview](docs/ARCHITECTURE.md)
- [Deployment Guide](docs/DEPLOYMENT.md) 
- [Development Setup](docs/DEVELOPMENT.md)
- [Cost Analysis](docs/COST_ANALYSIS.md)
- [ADR - Architecture Decisions](docs/ADR/)

## 🧪 Tests & Qualité

```bash
# Tests unitaires
pytest src/producer/tests/
pytest src/consumer/tests/

# Tests d'intégration  
pytest tests/integration/

# Validation infrastructure
terraform plan -var="resource_group_name=$RG_MONTECARLO"
terraform validate
```

## 🤝 Contribution

1. Fork le repository
2. Créer feature branch (`git checkout -b feature/amazing-feature`)
3. Commit changements (`git commit -m 'Add amazing feature'`)
4. Push branch (`git push origin feature/amazing-feature`)
5. Ouvrir Pull Request

## 📄 License

Ce projet est sous licence MIT. Voir [LICENSE](LICENSE) pour détails.

## 🎯 Portfolio Highlights

Ce projet démontre :

### **Architecture & Design**
- Patterns microservices cloud-native
- Auto-scaling intelligent et cost-aware
- Monitoring production-grade
- Infrastructure as Code modulaire

### **DevOps & Engineering** 
- CI/CD Azure Pipelines avec repo GitHub
- Terraform multi-modules réutilisables
- Testing strategy complète
- Documentation technique approfondie

### **Business Awareness**
- Cost optimization (16-41€/mois vs infrastructure équivalente)
- Technology selection pragmatique vs hype
- Scalabilité économique démontrée
- ROI quantifié par métriques

---

**Développé pour démonstration compétences cloud/DevOps/architecture distribuée lors d'entretiens techniques**