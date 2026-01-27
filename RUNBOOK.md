# 🛠 RUNBOOK – StartTech Application

Operations & Troubleshooting Guide

### Author: Jason Mwome
### Role: Senior DevOps Engineer
### Environment: AWS (Production)

## 📌 Purpose of This Runbook

This runbook provides step-by-step operational procedures and troubleshooting guidance for the StartTech full-stack application.

It is intended for:

DevOps engineers

- Site Reliability Engineers (SREs)

- On-call support engineers

## 1️⃣ System Overview

Architecture Summary:

- Frontend: React app hosted on S3 + CloudFront

- Backend: Golang API in Docker on EC2 Auto Scaling Group

- Load Balancing: Application Load Balancer (ALB)

- Caching: Redis (ElastiCache)

- Database: MongoDB Atlas

- CI/CD: GitHub Actions

- Monitoring: CloudWatch Logs & Metrics

## 2️⃣ Normal Operations
### 2.1 Frontend Operations
Check Frontend Availability
curl https://<cloudfront-domain>

Expected:

HTTP 200 response

React UI loads correctly
<img width="1920" height="1080" alt="Screenshot 2026-01-24 140035" src="https://github.com/user-attachments/assets/69bb005d-8320-4afc-b524-ac00a9fe6971" />

📸 Screenshot:
<img width="1920" height="1080" alt="Screenshot 2026-01-26 084358" src="https://github.com/user-attachments/assets/40fa1da0-f02d-499a-b79e-fdbfd56c1008" />


screenshots/frontend-cloudfront-working.png

### 2.2 Backend Operations
Health Check Endpoint
curl http://<ALB-DNS>/health
<img width="1920" height="790" alt="image" src="https://github.com/user-attachments/assets/ebb1ffbb-134d-44ae-acbb-91a5d8e20a47" />


Expected:

OK


📸 Screenshot:
<img width="1920" height="405" alt="image" src="https://github.com/user-attachments/assets/71b5be86-84c1-44d4-85b0-28d12e5da973" />


screenshots/backend-health-check.png

### 2.3 Auto Scaling Group Status

Check EC2 instances:

AWS Console → EC2 → Auto Scaling Groups

Ensure instances are InService

📸 Screenshot:

<img width="1920" height="1080" alt="Screenshot 2026-01-26 130618" src="https://github.com/user-attachments/assets/9aad39a2-0055-48f5-97a5-21426b45a484" />



### 2.4 Docker Image in ECR

Verify backend image exists:

AWS Console → ECR → starttech-backend

📸 Screenshot:

<img width="1920" height="1080" alt="Screenshot 2026-01-27 142832" src="https://github.com/user-attachments/assets/2979f3f3-925b-4317-adf2-870eaf3dd072" />

screenshots/ecr-backend-image.png

## 3️⃣ CI/CD Operations
### 3.1 Frontend Deployment Flow

Code pushed to main

GitHub Actions runs:

Install dependencies

Run tests

Build React app

Upload to S3

Invalidate CloudFront cache

📸 Screenshot:
<img width="1920" height="664" alt="image" src="https://github.com/user-attachments/assets/77bf039a-536a-4ada-b737-8d28d2ab5bf5" />



screenshots/frontend-github-actions-success.png

### 3.2 Backend Deployment Flow

Code pushed to main

GitHub Actions:

Run Go tests

Build Docker image

Push to ECR

Deploy via EC2/ASG

📸 Screenshot
<img width="1920" height="194" alt="image" src="https://github.com/user-attachments/assets/bf702a9e-2af9-4fbc-b5fc-846d35af88a4" />


screenshots/backend-github-actions-success.png

## 4️⃣ Monitoring & Logs
4.1 View Backend Logs

AWS Console:

CloudWatch → Log Groups

/starttech/backend

## 4.2 ALB Target Health

AWS Console:

EC2 → Target Groups → Targets

Healthy = ✅
Unhealthy = ❌

## 5️⃣ Common Issues & Troubleshooting
❌ Issue 1: 502 Bad Gateway from ALB

Cause:

Backend container not running

Health check path mismatch

Steps to Fix:

Check target group health

Confirm backend listens on port 8080

Verify /health endpoint exists

Check security group allows ALB → EC2 traffic

📸 Screenshot:
<img width="1920" height="394" alt="image" src="https://github.com/user-attachments/assets/c6b26897-7bd1-4968-93ad-7c78a35fe4ef" />

screenshots/alb-502-error.png

❌ Issue 2: GitHub Actions Not Triggering

Cause:

Workflow file in wrong repo

Incorrect branch trigger

PAT missing workflow scope

Fix:

Ensure .github/workflows/*.yml is in correct repository

Push to main

Check GitHub → Settings → Actions enabled


❌ Issue 3: Docker Push Fails

Cause:

Not logged into ECR

Image not tagged correctly

Fix:

aws ecr get-login-password --region us-east-1 \
| docker login --username AWS \
--password-stdin 597088021675.dkr.ecr.us-east-1.amazonaws.com

docker tag starttech-backend:latest \
597088021675.dkr.ecr.us-east-1.amazonaws.com/starttech-backend:latest

docker push 597088021675.dkr.ecr.us-east-1.amazonaws.com/starttech-backend:latest


📸 Screenshot:
<img width="1920" height="1080" alt="Screenshot 2026-01-26 143033" src="https://github.com/user-attachments/assets/973607fc-0a82-4b22-be0f-81372ef85b28" />

screenshots/docker-push-success.png

❌ Issue 4: Frontend Changes Not Visible

Cause:

CloudFront cache not invalidated

Fix:

aws cloudfront create-invalidation \
--distribution-id <DISTRIBUTION_ID> \
--paths "/*"


📸 Screenshot:

<img width="1920" height="1080" alt="Screenshot 2026-01-26 090929" src="https://github.com/user-attachments/assets/38b90ea3-85dd-4fc3-89c6-7c506d335109" />

screenshots/cloudfront-invalidation.png

## 6️⃣ Rollback Procedures
6.1 Backend Rollback

Revert Git commit

Push to main

GitHub Actions redeploys previous image

or

Re-tag previous Docker image in ECR

Redeploy ASG instances

### 6.2 Frontend Rollback
aws s3 sync s3://frontend-backup s3://starttech-frontend-bucket

## 7️⃣ Emergency Contacts & Ownership
### Role and  Responsibility
#### DevOps Engineer-Infrastructure & CI/CD
#### Backend Engineer-API & Services
#### Frontend Engineer-UI & Static Assets
## 8️⃣ Final Notes
✔ Infrastructure fully automated with Terraform
✔ CI/CD pipelines validated
✔ Monitoring and logging enabled
✔ Rollback strategies defined

This runbook ensures safe operation, fast troubleshooting, and production readiness of the StartTech platform.

