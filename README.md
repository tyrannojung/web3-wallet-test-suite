# Web3 Wallet Testing with Playwright & Docker
![Playwright](https://img.shields.io/badge/Playwright-45ba4b?style=for-the-badge&logo=Playwright&logoColor=white)
![MetaMask](https://img.shields.io/badge/MetaMask-F6851B?style=for-the-badge&logo=metamask&logoColor=white)
![Docker](https://img.shields.io/badge/docker-%230db7ed.svg?style=for-the-badge&logo=docker&logoColor=white)

Playwright와 MetaMask를 연동하여 Web3 dApp 테스트 자동화 환경을 구성하고, Docker로 스케줄링 테스트를 실행하는 예시 프로젝트입니다.

---

## 📁 프로젝트 구조

```bash
├── dapp-playwright/
│   ├── docker/             # Docker setup for running tests in isolated environments
│   │   ├── Dockerfile
│   │   └── docker-compose.yml
│   ├── src/                # Contains Playwright fixtures and supporting modules
│   │   └── wallet/
│   ├── tests/              # Playwright test cases organized for end-to-end testing
│   │   └── e2e.test.ts
│   ├── .env
│   ├── .env.example
│   ├── package.json
│   ├── playwright.config.ts
│   ├── run_tests.sh
│   └── tsconfig.json
├── terraform/
│   ├── modules/           # Reusable Terraform modules for infrastructure provisioning
│   ├── .terraform/
│   ├── variables.tf
│   ├── main.tf
│   ├── terraform.tfvars
│   └── terraform.tfvars.example
├── pnpm-workspace.yaml
├── .gitignore
├── tsconfig.json
└── README.md
```

---

## 🚀 시작하기 (Getting Started)

### 사전 준비사항
- Node.js (v14 이상)
- pnpm
- Docker
- MetaMask 계정(Seed Phrase 필요)

### 초기 설정

1. 저장소를 클론하고 의존성을 설치합니다:
```bash
git clone <repository-url>
pnpm install

# .env.example을 .env로 복사
cp .env.example .env
```
---

## 🌐 환경 변수 설정

dapp-playwright 디렉토리 내에 `.env` 파일을 생성하고 다음 내용을 추가합니다:
```plaintext
SEED_PHRASE=your_metamask_seed_phrase_here
PASSWORD=your_metamask_password_here
BASEURL=your_dapp_domain_here
```
---

## 💻 로컬 개발 및 테스트

1. 지갑 설정 초기화:
```bash
pnpm test:initial:basic
pnpm test:wallet
```
---

## 🐳 Docker를 통한 자동화 테스트

1. 도커 컨테이너 빌드 및 실행:
```bash
cd dapp-playwright/docker
docker-compose up -d
```
---

## 📝 Terraform을 통한 자동화 테스트

1. 변경되지 않은 스토리지를 재사용하기 위해 EBS 모듈을 먼저 초기화 및 적용합니다:
```bash
cd root/terraform/modules/ebs
terraform init
terraform apply -auto-approve
```

2. 루트 terraform 디렉토리로 이동하여 전체 인프라를 초기화 및 적용합니다:
```bash
cd root/terraform/
terraform init
terraform apply -auto-approve
```

