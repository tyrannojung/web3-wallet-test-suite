import {
    MetaMask,
    defineWalletSetup,
    getExtensionId,
  } from "@synthetixio/synpress";
  import "dotenv/config";
  
  // 사용할 지갑의 시드
  const SEED_PHRASE = process.env.SEED_PHRASE || "REQUIRED";
  // 시드 암호화를 위한 비밀번호
  const PASSWORD = process.env.PASSWORD || "REQUIRED";
  
  export default defineWalletSetup(PASSWORD, async (context, walletPage) => {
    // 메타마스크 초기 구성
    const extensionId = await getExtensionId(context, "MetaMask");
    const metamask = new MetaMask(context, walletPage, PASSWORD, extensionId);
  
    // 메타마스크 설정한 시드 임포트
    await metamask.importWallet(SEED_PHRASE);
  });
  