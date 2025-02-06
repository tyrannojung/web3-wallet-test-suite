import { testWithSynpress, metaMaskFixtures } from "@synthetixio/synpress";
import BasicSetup from "@/src/wallet/wallet.setup";
import "dotenv/config";

// Register MetaMask Fixtures
const test = testWithSynpress(metaMaskFixtures(BasicSetup));

const { expect } = test;
const PORT = process.env.PORT || 3000;
const BASEURL = process.env.BASEURL || `http://localhost:${PORT}`;

// Test suite for connecting the wallet to the dApp
test.describe("Connect Wallet to dApp", () => {
  test(`wallet test1`, async ({ page, metamask }) => {
    // Navigate to the dApp to interact with MetaMask
    await page.goto(BASEURL);

    // Click the "Connect Wallet" button on the Tokamak Bridge
    await page.locator("p").filter({ hasText: "Connect Wallet" }).click();

    // Allow connection with MetaMask on the corresponding page
    await metamask.connectToDapp();

    // Verify that the button element is removed from the DOM
    await expect(
      page.locator("p").filter({ hasText: "Connect Wallet" })
    ).toHaveCount(0);
  });
});
