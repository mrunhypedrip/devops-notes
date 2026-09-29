
Modul 05: Kubernetes Production Orchestration Manifests
1. Konsep & Industri Utility
Orkestrasi kontainer dengan fitur auto-scaling (HPA), resource limits, liveness probe, dan load balancing internal.

2. Diagram Kubernetes Architecture
Code snippet
graph TD
    SVC[Service ClusterIP] --> Pod1[Pod API 1]
    SVC --> Pod2[Pod API 2]
    SVC --> Pod3[Pod API 3]
    HPA[Horizontal Pod Autoscaler] -.->|CPU Target 70%| SVC
3. Komponen Utama
production-app.yaml : Kubernetes Deployment, Service, & HPA manifest.
