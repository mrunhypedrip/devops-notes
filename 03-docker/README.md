
Modul 03: Multi-Container Production Architecture
1. Konsep & Arsitektur
Arsitektur microservices terisolasi memisahkan Nginx Reverse Proxy, Python Flask API (Non-root user), dan Redis Cache Engine.

2. Diagram Topologi Arsitektur
Code snippet
graph TD
    Client[Client Browser] -->|Port 8080| Proxy[Nginx Proxy]
    subgraph Isolated Network: backend-net
        Proxy --> API[Python Flask API]
        API --> Cache[(Redis Cache)]
    end
3. Komponen Utama
Dockerfile : Multi-stage build Python API non-root user.

docker-compose.yml : Multi-container orchestrator.

nginx.conf : Reverse proxy config.
