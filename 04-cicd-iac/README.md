# Modul 04: CI/CD Pipeline Automation & Infrastructure as Code

## 1. Konsep & Industri Utility
Verifikasi kode otomatis via GitHub Actions (ShellCheck & Trivy Scanner) dan pengadaan infrastruktur cloud via Terraform AWS.

## 2. Diagram CI/CD Pipeline
```mermaid
graph LR
    Push[Git Push] --> Lint[ShellCheck]
    Lint --> Scan[Trivy Scanner]
    Scan --> Build[Docker Build Test]
```

## 3. Komponen Utama
- `.github/workflows/production-pipeline.yml` : GitHub Actions CI pipeline.
- `main.tf` : Terraform manifest untuk AWS VPC.
