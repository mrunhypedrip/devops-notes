# Minggu 5: Kubernetes Orchestration (kind / k3d)

## Concept Overview
- **Deployment:** Mengatur *desired state*, *scaling*, dan *rolling updates* untuk Pods.
- **Service:** Menyediakan IP stabil dan *load balancing* internal antar-Pod.

## Practice Commands (dengan kind/k3d/minikube)
- Apply Manifest: `kubectl apply -f deployment.yaml`
- Check Resources: `kubectl get pods,svc,deploy`
- Delete Resources: `kubectl delete -f deployment.yaml`
