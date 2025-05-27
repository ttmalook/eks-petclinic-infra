# eks-petclinic-infra

EKS 기반 Spring PetClinic 인프라 자동화 구성 프로젝트입니다.

## 📦 주요 구성 요소

### 🔹 VPC 및 EKS 클러스터
- `vpc-3tier.yaml`: CloudFormation 기반 VPC 3-Tier 구성
- `eks-cluster.yaml`: eksctl 기반 클러스터 정의

### 🔹 GitHub Actions 자동화
- `.github/workflows/create-eks.yaml`: EKS 클러스터 자동 생성 워크플로
- `.github/workflows/deploy-efs.yaml`: EFS StorageClass, PV, PVC 자동 배포 워크플로

### 🔹 EFS 구성
- `efs/storageclass.yaml`: EFS용 StorageClass
- `efs/efs-pv.yaml`: EFS PersistentVolume (volumeHandle = EFS ID 필요)
- `efs/efs-pvc.yaml`: PersistentVolumeClaim

### 🔹 PetClinic Helm Chart
- `charts/petclinic/`: Web/WAS 분리형 Helm Chart
  - Web (httpd), WAS (Spring Boot 내장 Tomcat)
  - `/web`, `/was` 경로 Ingress로 노출

## 🚀 사용 방법

### 1. GitHub Secrets 등록
- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`

### 2. GitHub Actions 워크플로 실행
- `Create EKS Cluster` → 클러스터 자동 생성
- `Deploy EFS Storage` → EFS PVC 구성

### 3. Helm Chart로 애플리케이션 배포
```bash
kubectl create ns petclinic
helm install petclinic ./charts/petclinic -n petclinic
```

---

작성: 2025  
작성자: ttmalook