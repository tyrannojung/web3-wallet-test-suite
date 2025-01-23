#!/bin/sh

cd /app/dapp-playwright

# 로그 디렉토리 설정
LOG_DIR="docker/log"
LOG_FILE="${LOG_DIR}/test_run.log"

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
 
 # Xvfb 종료
 kill $XVFB_PID
 
 return $TEST_EXIT_CODE
}

# 테스트 실행
run_test

echo "=== Test Completed at $(date) ===" >> $LOG_FILE