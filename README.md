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

docker logs -f cronjob_service
```
---

## 📝 사용 가능한 스크립트

**package.json** 예시:
```json
{
  "scripts": {
    "test:ui": "npx playwright test --ui",
    "test:debug": "PWDEBUG=1 npx playwright test --project=serial-tests",
    "test:initial:basic": "npx synpress ./src/wallet/",
    "test:report": "npx playwright show-report results/playwright-report",
    "test:wallet": "npx playwright test test/wallet/wallet.test.ts"
  }
}
```
