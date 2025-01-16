import { defineConfig, devices } from "@playwright/test";
import dotenv from "dotenv";
import path from "path";
import { fileURLToPath } from "url";

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

// .env 파일 로드
dotenv.config({ path: path.resolve(__dirname, ".env") });

const PORT = process.env.PORT || 3000;
const baseURL = process.env.BASEURL || `http://localhost:${PORT}`;

export default defineConfig({
  testDir: "./test", // 테스트 파일이 있는 디렉토리 설정
  timeout: 120_000, // 테스트 단위 1당 2분
  fullyParallel: true, // 모든 테스트 파일을 병렬로 실행할지 여부를 결정
  reporter: [
    ["html", { outputFolder: "results/playwright-report", open: "never" }], // HTML 리포터 설정과 경로
  ], // 테스트 결과를 보여주는 리포터 html 포맷 설정
  use: {
    baseURL, //테스트에 사용할 기본 URL
    headless: true, // 해드리스 모드(GUI 없이 소프트웨어 프로그램 실행 의미) 사용 여부 결정, false는 GUI 모드로 실행됨
    video: "off", // 녹화여부 결정
    colorScheme: "dark", // 다크 모드 활성화
    trace: "on", // trace mode on
  },
  workers: 1, // 병렬로 실행되는 테스트 수 제한
  projects: [
    {
      name: "wallet-tests",
      testDir: "./test",
      testMatch: "**/*.test.ts",
      fullyParallel: false,
      use: { ...devices["Desktop Chrome"] },
    }
  ],
  outputDir: "results/test-results",
});
