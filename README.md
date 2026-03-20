# Enterprise Event-Driven DevOps Platform

## Overview

This project demonstrates a modern enterprise-grade DevOps and Platform Engineering architecture built on AWS using Kubernetes (EKS), GitOps, CI/CD, and secure event-driven microservices.

The platform simulates a real-world transaction processing system powered by Kafka and MongoDB, enhanced with centralized CI/CD, API Gateway, identity management, and secrets management.

---

## Architecture Overview

The platform is designed using layered architecture principles:

### 1. Infrastructure Layer (Terraform)

* AWS VPC, subnets, NAT Gateway, Internet Gateway
* EKS Cluster with managed node groups
* Remote state using S3 + DynamoDB
* Modular Terraform structure:

  * `network`
  * `eks`
  * `addons`

---

### 2. Kubernetes Addons

Deployed via Terraform (Helm):

* ArgoCD (GitOps engine)
* ingress-nginx
* Prometheus + Grafana (Monitoring)
* MongoDB
* EBS CSI Driver
* Metrics Server

---

### 3. GitOps Layer (ArgoCD)

* Centralized configuration via `cluster-config`
* Root application manages:

  * infrastructure apps
  * monitoring stack
  * future application deployments

---

### 4. Application Layer

* Transaction processing microservice
* Kafka-based event consumption
* MongoDB persistence
* Packaged via Helm

---

### 5. API Gateway Layer

* Kong API Gateway
* Handles:

  * routing
  * rate limiting
  * authentication enforcement
  * API exposure

---

### 6. Identity & Security Layer

#### PingFederate (OIDC Provider)

* Token-based authentication (OAuth2 / OIDC)
* Issues access tokens for services and users
* Integrated with Kong for request validation

#### Conjur (Secrets Management)

* Secure secret injection into Kubernetes workloads
* Dynamic credential management
* Replaces static Kubernetes secrets

---

### 7. CI/CD Layer

* Jenkins with shared library
* Standardized pipeline using `build_config.yaml`
* Centralized pipeline logic

Pipeline flow:

```
Code Commit → Jenkins Pipeline → Docker Build → Push Image → Update Values → ArgoCD Sync
```

---

### 8. Observability Layer

* Prometheus for metrics collection
* Grafana for dashboards
* Node exporter and kube-state-metrics
* Future:

  * Kafka metrics
  * Application-level metrics
  * Alerting rules

---

## Repository Structure

```id="repo1"
devops-platform/
├── infra-live/
│   ├── network/
│   ├── eks/
│   └── addons/
├── cluster-config/
│   ├── argocd/
│   └── infrastructure/
├── cicd-platform/
│   ├── jenkins-pipelines/
│   └── jenkins-shared-lib/
├── transaction-service/
│   ├── build_config.yaml
│   └── values.yaml
├── scripts/
└── README.md
```

---

## Helm Strategy (Centralized)

* Helm charts are **centralized and reusable**
* Application repositories contain only:

  * `values.yaml`
  * `build_config.yaml`

Benefits:

* Standardized deployments
* Reusable templates
* Separation of concerns

---

## Lifecycle Management

### Apply Infrastructure

```id="cmd1"
./scripts/apply-all.sh
```

### Destroy Infrastructure

```id="cmd2"
./scripts/destroy-all.sh
```

Execution Order:

```
Apply:    network → eks → addons
Destroy:  addons → eks → network
```

---

## Monitoring Access

```id="cmd3"
kubectl port-forward svc/monitoring-grafana -n monitoring 3000:80
kubectl port-forward svc/monitoring-kube-prometheus-prometheus -n monitoring 9090
```

---

## Current Status

### Completed

* Infrastructure provisioning (Terraform)
* EKS cluster setup
* Addons deployment
* Monitoring (Prometheus + Grafana)
* GitOps setup (ArgoCD)
* Clean lifecycle (apply/destroy)

### In Progress

* Transaction service deployment via ArgoCD
* Kafka integration
* CI/CD pipeline setup (Jenkins)
* Centralized Helm implementation

### Planned

* Kong API Gateway integration
* PingFederate authentication flow
* Conjur secrets integration
* Kafka → Service → MongoDB event pipeline
* Advanced observability dashboards
* MLOps integration

---

## Key Capabilities

* Infrastructure as Code (Terraform)
* Kubernetes (EKS)
* GitOps (ArgoCD)
* Event-driven architecture (Kafka)
* Observability (Prometheus, Grafana)
* CI/CD standardization (Jenkins)
* API Gateway (Kong)
* Identity management (PingFederate)
* Secrets management (Conjur)

---

## Future Enhancements

* Multi-environment support (dev/stage/prod)
* Blue/Green and Canary deployments
* Service Mesh (Istio/Linkerd)
* Advanced security policies
* MLOps pipeline for anomaly detection

---

## Notes

* Terraform state is stored remotely (S3)
* `.terraform` and `.tfstate` are ignored
* `.terraform.lock.hcl` is version-controlled
* Helm charts are centrally managed

---

## Author

Ashutosh Pandey

---

## License

This project is intended for learning and demonstration purposes.

