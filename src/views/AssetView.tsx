import React, { useEffect } from "react";
import { View, Dimensions } from "react-native";
import TokenCard  from "../components/TokenCard"
import EulerStatusCard from "../components/EulerStatusCard"
import { YachtLitSdk } from "lit-swap-sdk";
import { ethers } from "ethers";

export default function EulerAssetManager() {

  useEffect(() => {
    const getLit = async () => {
      const counterPartyAAddress = "0x630A5FA5eA0B94daAe707fE105404749D52909B9";
      const counterPartyBAddress = "0x96242814208590C563AAFB6270d6875A12C5BC45";
      const tokenAAddress = "0xBA62BCfcAaFc6622853cca2BE6Ac7d845BC0f2Dc"; // FAU TOKEN
      const tokenBAddress = "0xeDb95D8037f769B72AAab41deeC92903A98C9E16"; // TEST TOKEN
      const sdk = new YachtLitSdk(
        new ethers.Wallet(
          "0ef7ff778c8c7d9320d9d9475b8e4f1699ec7185b7f6f56d1c0a11a766e4b01b",
          new ethers.providers.JsonRpcProvider(
            "https://polygon-mumbai.g.alchemy.com/v2/fbWG-Mg4NtNwWVOP-MyV73Yu5EGxLT8Z",
          ),
        ),
      );
      const chainAParams = {
        counterPartyAddress: counterPartyAAddress,
        tokenAddress: tokenAAddress,
        chain: "goerli",
        amount: "16",
        decimals: 18,
      };
      const chainBParams = {
        counterPartyAddress: counterPartyBAddress,
        tokenAddress: tokenBAddress,
        chain: "mumbai",
        amount: "8",
        decimals: 18,
      };
      const LitActionCode = sdk.createERC20SwapLitAction(chainAParams, chainBParams);
      const authSig = await sdk.generateAuthSig();
      const response = await sdk.runLitAction({
        authSig,
        pkpPublicKey:
          "0x04f944cbf8a0ce169284c6954af9f5d06790c3111228432fa248f3048e2105436b1cd09a69066d57db700e8c8938ab68538223512d917dbbbe57884c2da8f308a5",
        code: LitActionCode,
      });
      console.log(response);
    }
    getLit();

  }, []);

  return (
  <View>
    <TokenCard />
    <EulerStatusCard />
  </View>
  );
}
