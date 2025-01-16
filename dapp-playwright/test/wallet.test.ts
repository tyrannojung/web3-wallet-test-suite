import { testWithSynpress, metaMaskFixtures } from "@synthetixio/synpress";
import BasicSetup from "@/src/wallet/wallet.setup";
import "dotenv/config";

// 메타마스크 Fixtures 등록
const test = testWithSynpress(metaMaskFixtures(BasicSetup))

const { expect } = test;
const PORT = process.env.PORT || 3000;
const BASEURL = process.env.BASEURL || `http://localhost:${PORT}`;
console.log(BASEURL)


// Test suite for connecting the wallet to the dApp
test.describe("Connect Wallet to dApp", () => {
  test(`wallet test1`, async ({ page, metamask }) => {
    console.log("Environment BASEURL:", process.env.BASEURL);
    // 메타마스크와 상호작용할 브라우저(토카막 브릿지 페이지) 이동
    await page.goto(BASEURL);

    // 토카막 브릿지 Connect Wallet 클릭
    await page.locator("p").filter({ hasText: "Connect Wallet" }).click();

    // 메타마스크 해당 페이지와 연결 허용 클릭
    await metamask.connectToDapp();

  });
});
