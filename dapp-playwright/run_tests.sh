#!/bin/sh

cd /app/dapp-playwright

# 최신 코드를 가져옵니다 (git pull)
git --git-dir=/app/.git --work-tree=/app pull origin main

# 로그 디렉토리 설정
LOG_DIR="docker/log"
LOG_FILE="${LOG_DIR}/test_run.log"
REPORT_DIR="/app/dapp-playwright/reports"
TODAY=$(date +%Y%m%d)
TIMESTAMP=$(date +%H%M%S)
mkdir -p "$LOG_DIR"

# 로그 시작 시간 기록
echo "=== Test Started at $(date) ===" >> $LOG_FILE

# Playwright 브라우저 설치 확인
if [ ! -d "/root/.cache/ms-playwright" ]; then
 echo "Installing Playwright browsers..." >> $LOG_FILE
 pnpm exec playwright install
fi

# MetaMask 캐시 설정
if [ ! -d "/app/.cache-synpress" ]; then
  xvfb-run pnpm exec synpress ./src/wallet >> $LOG_FILE 2>&1
  pkill Xvfb
fi

# 테스트 실행 및 결과 저장
run_test() {
  echo "Starting test:wallet at $(date)" >> $LOG_FILE

  # Xvfb 시작
  Xvfb :99 -screen 0 1280x1024x24 &
  XVFB_PID=$!
  export DISPLAY=:99

  # 테스트 실행
  pnpm test:wallet >> $LOG_FILE 2>&1
  TEST_EXIT_CODE=$?

  # 리포트 저장
  if [ -d "results/playwright-report" ]; then
    REPORT_SUBDIR="${REPORT_DIR}/${TODAY}/${TIMESTAMP}"
    mkdir -p "$REPORT_SUBDIR"
    cp -r results/playwright-report/* "$REPORT_SUBDIR"
    rm -rf results/playwright-report
    echo "Test report moved to ${REPORT_SUBDIR}" >> $LOG_FILE
  fi

  # Xvfb 종료
  kill $XVFB_PID

  return $TEST_EXIT_CODE
}
# 테스트 실행
run_test

echo "=== Test Completed at $(date) ===" >> $LOG_FILE

# Git 명령 실행
cd /app  # Git 저장소의 루트 디렉토리로 이동

# 리포트 폴더만 푸시
echo "Pushing report folder to main branch..." >> $LOG_FILE
git --git-dir=/app/.git --work-tree=/app add "${REPORT_DIR}"
git --git-dir=/app/.git --work-tree=/app commit -m "test: ${TODAY}_${TIMESTAMP} wallet test report"
git --git-dir=/app/.git --work-tree=/app push origin main