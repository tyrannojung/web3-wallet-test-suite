# 베이스 이미지로 특정 버전의 Playwright 이미지를 사용합니다.
FROM mcr.microsoft.com/playwright:v1.45.1-jammy

# npm을 최신 버전으로 업그레이드
RUN npm install -g npm@latest

# pnpm을 최신 버전으로 설치
RUN npm install -g pnpm@latest

# 환경 변수 설정 (선택적 종속성 설치 활성화)
ENV NPM_CONFIG_OPTIONAL=true


# 시스템 패키지 설치 및 타임존 설정
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    git \
    busybox \
    tzdata \
    cron \
    xvfb && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    ln -sf /usr/share/zoneinfo/Asia/Seoul /etc/localtime && \
    echo Asia/Seoul > /etc/timezone

# 프로젝트 의존성을 pnpm으로 설치합니다.
RUN pnpm install --optional

# Playwright 런타임에 필요한 시스템 종속성을 설치합니다.
RUN pnpm exec playwright install-deps

# Playwright에서 사용하는 브라우저들을 설치합니다.
RUN pnpm exec playwright install


# 작업 디렉토리 설정
WORKDIR /app

# workspace 설정 파일 복사
COPY pnpm-workspace.yaml /app/

# 프로젝트 파일 복사
COPY dapp-playwright /app/dapp-playwright
WORKDIR /app/dapp-playwright

# 의존성 설치
ENV NPM_CONFIG_OPTIONAL=true
RUN pnpm install --optional

# run_tests.sh에 실행 권한 부여
RUN chmod 755 /app/dapp-playwright/run_tests.sh

# Cron 작업 설정 (예: 매분 실행)
RUN echo 'SHELL=/bin/sh' > /etc/cron.d/run_tests && \
    echo '* * * * * root /app/dapp-playwright/run_tests.sh > /dev/null 2>&1' >> /etc/cron.d/run_tests && \
    chmod 0644 /etc/cron.d/run_tests && \
    crontab /etc/cron.d/run_tests

# Cron 실행 및 로그 모니터링
CMD /bin/sh -c '\
    mkdir -p /app/dapp-playwright/docker/test && \
    touch /app/dapp-playwright/docker/test/cron.log && \
    touch /app/dapp-playwright/docker/test/test_run.log && \
    cron -L 0 && \
    tail -f /app/dapp-playwright/docker/test/test_run.log'