#!/bin/bash

# AWS 리전 설정
REGION="ap-northeast-2"

# 1. 기본 VPC 및 CIDR 조회
VPC_ID=$(aws ec2 describe-vpcs --query "Vpcs[0].VpcId" --output text --region $REGION)
CIDR_BLOCK=$(aws ec2 describe-vpcs --query "Vpcs[0].CidrBlock" --output text --region $REGION)

echo "VPC ID: $VPC_ID"
echo "CIDR: $CIDR_BLOCK"

# 2. ALB SG 생성
aws ec2 create-security-group   --group-name alb-sg   --description "ALB SG for internet access"   --vpc-id $VPC_ID   --region $REGION

ALB_SG_ID=$(aws ec2 describe-security-groups --filters Name=group-name,Values=alb-sg --query 'SecurityGroups[0].GroupId' --output text --region $REGION)

aws ec2 authorize-security-group-ingress --group-id $ALB_SG_ID --protocol tcp --port 80 --cidr 0.0.0.0/0 --region $REGION
aws ec2 authorize-security-group-ingress --group-id $ALB_SG_ID --protocol tcp --port 443 --cidr 0.0.0.0/0 --region $REGION

# 3. EFS SG 생성
aws ec2 create-security-group   --group-name efs-sg   --description "EFS SG to accept mount from EKS nodes"   --vpc-id $VPC_ID   --region $REGION

EFS_SG_ID=$(aws ec2 describe-security-groups --filters Name=group-name,Values=efs-sg --query 'SecurityGroups[0].GroupId' --output text --region $REGION)

# 4. EKS Node SG 조회
EKS_NODE_SG=$(aws ec2 describe-security-groups   --filters Name=group-name,Values="*nodes*"   --query 'SecurityGroups[0].GroupId' --output text --region $REGION)

# 5. Node → EFS 허용
aws ec2 authorize-security-group-ingress   --group-id $EFS_SG_ID   --protocol tcp --port 2049   --source-group $EKS_NODE_SG   --region $REGION

# 6. ALB → Node 허용 (NodePort 접근)
aws ec2 authorize-security-group-ingress   --group-id $EKS_NODE_SG   --protocol tcp --port 30000-32767   --source-group $ALB_SG_ID   --region $REGION

# 7. Pod 간 통신 허용
aws ec2 authorize-security-group-ingress   --group-id $EKS_NODE_SG   --protocol all --port all   --source-group $EKS_NODE_SG   --region $REGION

echo "보안 그룹 설정이 완료되었습니다."
