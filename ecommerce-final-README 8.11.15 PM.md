# 🛒 Secure E-Commerce App on AWS EKS

This project is a full-featured e-commerce platform with a React frontend and Node.js backend, fully containerized and deployed on **AWS EKS** with robust DevSecOps practices including Terraform infrastructure, CI/CD, Helm charts, and advanced security controls.

---

## 📁 Project Structure

```
ecommerce-mini-app/
├── backend/              # Node.js API
├── frontend/             # React frontend
├── infra/                # Terraform for AWS (VPC, EKS, RDS, IAM, WAF, etc.)
├── helm-charts/          # Helm templates for K8s deployment
├── .github/workflows/    # CI/CD pipelines using GitHub Actions
├── external-secrets/     # K8s External Secrets integration with AWS
├── opa-gatekeeper/       # Kubernetes policy enforcement
└── README.md             # Project documentation
```

---

## 🚀 Deployment Guide

### 1. 📦 Infrastructure Setup (Terraform)

```bash
cd infra
terraform init
terraform apply
```

Resources provisioned:
- VPC with public/private subnets
- EKS Cluster
- ECR repos
- PostgreSQL via RDS
- WAF, GuardDuty
- ACM TLS certificate (DNS-validated)
- IAM roles for IRSA and CI/CD

---

### 2. 🧑‍💻 Application Setup

- **Frontend**: React app with dummy product list
- **Backend**: Express API serving product data

Each service includes a Dockerfile for containerization.

---

### 3. 🔁 CI/CD with GitHub Actions

Workflow:
- On `push` to `main`:
  - Builds and pushes Docker images to ECR
  - Deploys to EKS using Helm
  - Scans for vulnerabilities with Trivy

Secrets needed in GitHub:
- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`
- `BACKEND_IMAGE`
- `FRONTEND_IMAGE`

---

### 4. 📦 Deploy with Helm

```bash
helm upgrade --install backend ./helm-charts/backend
helm upgrade --install frontend ./helm-charts/frontend
```

Configure values for:
- Image repo
- Ingress host/domain
- Secrets

---

### 5. 🔐 Secrets Management (AWS Secrets Manager + External Secrets)

Create secrets in AWS:
```
aws secretsmanager create-secret --name ecommerce/db --secret-string '{"password":"your-password"}'
```

Deploy the CRD + SecretStore in Kubernetes:
```bash
kubectl apply -f secret_store.yaml
kubectl apply -f external_secrets_crd.yaml
```

---

### 6. 🔐 TLS + HTTPS

Use `acm_certificate.tf`:
- Updates ALB ingress to use HTTPS with ACM
- DNS validation through Route 53

---

### 7. 📏 OPA Gatekeeper (Security Policy)

Enforce security constraints:
```bash
kubectl apply -f opa-gatekeeper/constraint-template.yaml
kubectl apply -f opa-gatekeeper/constraint.yaml
```

Rules:
- Pods must include `app` and `env` labels
- (You can extend to block privileged containers, unsafe mounts, etc.)

---

### ✅ Security Controls

| Control | Description |
|--------|-------------|
| IAM | Least-privileged roles for EKS, CI/CD |
| IRSA | Secure pod access to AWS |
| WAF | Protects public endpoints |
| GuardDuty | Detects crypto mining, lateral movement |
| OPA/Gatekeeper | Policy-based enforcement in K8s |
| External Secrets | No hardcoded secrets in containers |
| HTTPS | Enforced via ACM & Ingress |
| CI/CD | Uses GitHub Actions with Trivy/Snyk scanning |

---

## 📊 Monitoring & Logging (Optional Enhancements)

- CloudWatch logs for containers and EKS control plane
- Prometheus + Grafana for metrics
- FluentBit → Chronicle or other SIEM

---

## 🧼 Cleanup

```bash
cd infra
terraform destroy
```

---

## 🧠 Author

Built by **Oluwachei** — DevSecOps Lead. This project showcases secure cloud-native architecture with end-to-end automation on AWS.

