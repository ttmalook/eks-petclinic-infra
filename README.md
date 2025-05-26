# eks-petclinic-infra

EKS 기반 Spring PetClinic 인프라 자동화 구성

## 포함된 구성 요소

### 1. VPC & EKS
- `vpc-3tier.yaml`: CloudFormation 기반 VPC 구성 (Public/Private Subnet 포함)
- `eks-cluster.yaml`: `eksctl`로 클러스터 + 노드그룹 생성

### 2. GitHub Actions 워크플로
- `.github/workflows/create-eks.yaml`: 클러스터 자동 생성
- `.github/workflows/deploy-efs.yaml`: EFS StorageClass, PV, PVC 자동 생성

### 3. EFS 구성
- `efs/storageclass.yaml`: EFS StorageClass
- `efs/efs-pv.yaml`: EFS PersistentVolume
- `efs/efs-pvc.yaml`: EFS PVC (WAS에 마운트됨)

### 4. PetClinic Helm Chart
- `charts/petclinic/`: Web/WAS 분리 Helm Chart
- `deployment-*.yaml`, `service-*.yaml`, `ingress.yaml` 포함

## 실행 순서

1. GitHub Secrets 등록:
   - `AWS_ACCESS_KEY_ID`
   - `AWS_SECRET_ACCESS_KEY`

2. `create-eks.yaml` 워크플로 실행
3. `deploy-efs.yaml` 워크플로 실행
4. Helm Chart 배포:
```bash
kubectl create ns petclinic
helm install petclinic ./charts/petclinic -n petclinic
```

---
작성: 2025