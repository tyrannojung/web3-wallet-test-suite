# 베이스 이미지 설정
FROM mcr.microsoft.com/playwright:v1.45.1-jammy

# Node.js 최신 버전 설치
RUN apt-get update && \
    curl -fsSL https://deb.nodesource.com/setup_22.x | bash - && \
    apt-get install -y nodejs && \
    node -v && npm -v

# npm 및 pnpm 최신 버전 설치
RUN npm install -g npm@latest
RUN npm install -g pnpm@latest

# 빌드 컨텍스트의 .git 디렉토리를 컨테이너의 /app/.git으로 복사합니다.
COPY .git /app/.git

COPY ./dapp-playwright /app/dapp-playwright

# 작업 디렉토리 설정
WORKDIR /app/dapp-playwright

# node_modules 및 lock 파일 삭제
RUN rm -rf node_modules package-lock.json pnpm-lock.yaml

# 패키지 업데이트 및 git 설치
RUN apt-get update && apt-get install -y git

# Git 설정을 위한 빌드 시 변수(ARG)를 선언합니다.
ARG GITHUB_TOKEN
ARG GIT_USER_NAME
ARG GIT_USER_EMAIL

# Git 전역 설정을 적용합니다.
RUN git config --global user.name "${GIT_USER_NAME}" && \
    git config --global user.email "${GIT_USER_EMAIL}" && \
    git config --global url."https://${GITHUB_TOKEN}@github.com/".insteadOf "https://github.com/"


# 프로젝트 의존성 설치
RUN pnpm install --optional

# Playwright 및 시스템 의존성 설치
RUN pnpm exec playwright install-deps
RUN pnpm exec playwright install

# 스크립트 실행 권한 부여 및 추가 패키지 설치
RUN chmod +x ./run_tests.sh && \
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    busybox \
    tzdata \
    cron \
    xvfb && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    ln -sf /usr/share/zoneinfo/Asia/Seoul /etc/localtime && \
    echo Asia/Seoul > /etc/timezone

# Cron 작업 추가
RUN echo 'SHELL=/bin/sh' > /etc/cron.d/run_tests && \
    echo '* * * * * root /app/dapp-playwright/run_tests.sh > /dev/null 2>&1' >> /etc/cron.d/run_tests && \
    chmod 0644 /etc/cron.d/run_tests && \
    crontab /etc/cron.d/run_tests

# Cron 실행 및 로그 확인
CMD /bin/sh -c '\
    mkdir -p ./docker/log && \
    touch ./docker/log/test_run.log && \
    cron -L 0 && \
    tail -f ./docker/log/test_run.log'
