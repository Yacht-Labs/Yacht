import { ethers } from "ethers";
import { JsonRpcProvider } from "@ethersproject/providers";

export const getID_TO_PROVIDER = (id: number): JsonRpcProvider => {
  switch (id) {
    case 5: // Goerli
      return new JsonRpcProvider(
        "https://eth-goerli.g.alchemy.com/v2/RZYixkcKT7io37tj7KCobPlyVB1IOciO"
      );
    case 80001: // Mumbai
      return new JsonRpcProvider(
        "https://endpoints.omniatech.io/v1/matic/mumbai/public"
      );
    default:
      throw new Error(`Chain id: ${id} not supported`);
  }
};
