# 🚀 StartTech Full-Stack Application: Comprehensive Setup & Deployment Guide
By Jason Mwome

This guide documents the entire deployment process of the StartTech full-stack application on AWS. It covers infrastructure provisioning, backend and frontend deployment, CI/CD pipelines, and monitoring, with screenshots and explanations for each step.
## 🏗 1️⃣ Infrastructure Deployment (Terraform)
Objective: Deploy all required AWS resources automatically with Terraform.
### Steps:

1.Navigate to your Terraform folder:
cd starttech-infra/terraform
2.Initialize Terraform:
Initialize Terraform:
3.Apply Terraform configuration:
terraform apply

### screenshot
<img width="1920" height="1080" alt="Screenshot 2026-01-23 115752" src="https://github.com/user-attachments/assets/f2aa5adf-5a64-46e8-81f3-5e66fcd49c54" />

Explanation:
Terraform provisions the following resources:

S3 bucket for frontend hosting

CloudFront distribution for global delivery

Application Load Balancer (ALB) with target group

EC2 Auto Scaling Group for backend

ElastiCache Redis cluster
### ALB Target Group

### Screenshot:
<img width="1920" height="1080" alt="Screenshot 2026-01-26 141341" src="https://github.com/user-attachments/assets/48d7f799-8e92-498b-9478-b217413e1181" />



Explanation:
The backend EC2 instances are registered with the ALB target group. The health check status is visible here.
.

### 🖥 2️⃣ Backend Deployment (Golang API + Docker)
Backend Health Check

Endpoint: /health

Screenshot:
<img width="1920" height="1080" alt="Screenshot 2026-01-26 091002" src="https://github.com/user-attachments/assets/23e74881-3add-48fe-91e8-34e34c8b7297" />


Explanation:
Confirms the Golang API is running on the backend EC2 instances.
Docker & Amazon ECR

### Steps:

Build the Docker image:

docker build -t starttech-backend:latest .


Tag the image for ECR:

docker tag starttech-backend:latest 597088021675.dkr.ecr.us-east-1.amazonaws.com/starttech-backend:latest


Push the image to ECR:

docker push 597088021675.dkr.ecr.us-east-1.amazonaws.com/starttech-backend:latest


### Screenshot:
<img width="1920" height="1080" alt="Screenshot 2026-01-26 143033" src="https://github.com/user-attachments/assets/c9809bf9-ff5a-44df-a64d-6427df8e46b7" />


Explanation:
The backend Docker image is stored in Amazon ECR, ready for deployment to EC2.

EC2 Auto Scaling Group

### Screenshot:
<img width="1920" height="1080" alt="Screenshot 2026-01-26 130618" src="https://github.com/user-attachments/assets/d4623013-21d5-4992-9df7-1b48d42300e2" />


Explanation:
Auto Scaling ensures high availability of backend instances based on demand.

### 🌐 3️⃣ Frontend Deployment (React + S3 + CloudFront)
React App Build

### Steps:

cd starttech-application/frontend
npm install
npm run build


### Screenshot:
<img width="1920" height="1080" alt="Screenshot 2026-01-24 043756" src="https://github.com/user-attachments/assets/79b3d188-4ed1-462d-a705-dd7e382b66c1" />



Explanation:
The React application is built and production-ready.

S3 & CloudFront

Upload build files:

aws s3 sync build/ s3://starttech-frontend-91f8eeab/


### Screenshot:
<img width="1920" height="1080" alt="Screenshot 2026-01-26 110000" src="https://github.com/user-attachments/assets/55b1ce43-6b40-4197-86a2-d0de5e24e5e5" />


S3 Bucket Files:

CloudFront Distribution:

Explanation:
Static frontend files are served globally via CloudFront CDN.

### ⚙️ 4️⃣ CI/CD Pipelines (GitHub Actions)
Backend Workflow

Steps: Test → Build Docker → Push to ECR → Deploy to EC2

### Screenshot:
<img width="1920" height="1080" alt="Screenshot 2026-01-27 085756" src="https://github.com/user-attachments/assets/56cd3a84-d8c2-4620-8a65-c001a1f5480f" />


Explanation:
Automates backend deployment, tests, and ensures containerized delivery.

Frontend Workflow

Steps: Test → Build React → Deploy to S3 → CloudFront Invalidate

### Screenshot:
<img width="1920" height="1080" alt="Screenshot 2026-01-24 134353" src="https://github.com/user-attachments/assets/0643fddf-4585-42f6-a120-7659853bc0f9" />


Explanation:
Frontend deployment is automated, ensuring the latest build is always live.

### 📊 5️⃣ Monitoring & Observability

CloudWatch Setup:

Logs for backend API

Health metrics for EC2 instances

Monitoring Redis cluster


Explanation:
Centralized logging allows easy debugging and operational monitoring.

### 📝 6️⃣ Folder Structure
starttech-infra/
├── terraform/
├── scripts/
└── monitoring/

starttech-application/
├── frontend/
├── backend/
└── .github/workflows/
### Frontend Application URL:
https://d3jy76eakc971h.cloudfront.net

### Backend Application URL:
http://starttech-alb-301593755.us-east-1.elb.amazonaws.com


### ✅ 7️⃣ Summary

This deployment establishes a fully automated CI/CD pipeline for the StartTech full-stack application:

Frontend: React + S3 + CloudFront

Backend: Golang + Docker + EC2 + Auto Scaling

Caching: Redis

Database: MongoDB Atlas

Monitoring: CloudWatch

CI/CD: GitHub Actions

Even initial ALB 502 errors are valid and expected during deployment testing.

CloudWatch log groups for observability

⚠️ ALB initially may show 502 Bad Gateway because backend instances are not yet running. This demonstrates correct load balancer behavior.
