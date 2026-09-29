# Modul 03: Multi-Container Production Architecture

## 1. Konsep & Arsitektur
Arsitektur microservices terisolasi memisahkan Nginx Reverse Proxy, Python Flask API (Non-root user), dan Redis Cache Engine.

2# 2. Diagram Topologi Arsitektur (Mermaid)
```mermaid
graph TD
    Client[Client Browser] -->|Port 8080| Proxy[Nginx Proxy]
    subgraph Isolated Network: backend-net
        Proxy --> API[Python Flask API]
        API --> Cache[(aRedis Cache)]
    end
```
