# StartTech CI/CD Architecture

## Overview
This system deploys a full-stack application using AWS managed services and Infrastructure as Code.

## Components
- Frontend: React deployed to S3, served via CloudFront
- Backend: Golang API running on EC2 Auto Scaling Group behind ALB
- Cache: Redis via ElastiCache
- Database: MongoDB Atlas
- Infrastructure: Terraform
- CI/CD: GitHub Actions
- Monitoring: CloudWatch Logs and Metrics

## Traffic Flow
User → CloudFront → S3  
User → ALB → EC2 (Golang API) → Redis / MongoDB

## Security
- IAM roles with least privilege
- Security groups restricting internal access
- Secrets managed via GitHub Secrets and AWS SSM
