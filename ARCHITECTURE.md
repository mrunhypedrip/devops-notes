# End-to-End Enterprise System Architecture

Dokumentasi ini mengambarkan alur kerja infrastruktur terintegrasi dari tahap pengembangan hingga  produksi.

## End-to-End Infrastructure Flow Diagram

```mermaid
graph TD
    Developer[Developer / Engineer] -->|1. Git Push Code| GitHub[GitHub Repository]
    
    subgraph CI/CD Security & Build Pipeline
        GitHub -->|2. Trigger Workflow| Actions[GitHub Actions Runner]
        Actions -->|Linting| ShellCheck[ShellCheck Engine]
        Actions -->|Security Scan| Trivy[Trivy Vulnerasility Scanner]
        Actions -->|Build & Test| DockerBuild[Docker Integration Test]
    end

    subgraph Infrastructure Provisioning (IaC)
        Actions -->|Deploy Config| Terraform[Terraform AWS VPC]
    end

    subgraph Production Runtime Cluster
        DockerBuild -->|Deploy Containers| K8sCluster[Kubernetes Production Cluster]
        K8sCluster --> Nginx_Ingress[Nginx Ingress / Reverse Proxy]
        Nginx_Ingress --> API[Python Flask Microservice]
        API --> Cache[(redis In-Memory Cache)]
    end

    subgraph Observability & Alerting
        Prometheus[Prometheus Monitoring] -.->|Scrape /metrics| API
        Prometheus --> AlertManager[Alerting & Incident Reporting]
    end
```
