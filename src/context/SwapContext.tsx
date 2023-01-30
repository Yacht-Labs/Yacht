import React, {PropsWithChildren, useState} from 'react';

export interface LitSwapChainParams {
  chainAParams: {
    counterPartyAddress: string;
    chain: string;
    amount: string;
    decimals: string;
    tokenAddress: string;
    symbol: string;
  },
  chainBParams: {
    counterPartyAddress: string;
    chain: string;
    amount: string;
    decimals: string;
    tokenAddress: string;
    symbol: string;
  }
}

export interface PKPInfo {
  ipfsCID: string,
  publicKey: string,
  address: string
}

const swapData = {
  chainAParams: {
      counterPartyAddress: "",
      chain: "",
      amount: "",
      decimals: "",
      tokenAddress: "",
      symbol: "",
  },
  chainBParams: {
      counterPartyAddress: "",
      chain: "",
      amount: "",
      decimals: "",
      tokenAddress: "",
      symbol: "",
  },
  address: "",
  publicKey: "",
  ipfsCID: ""
}

export const SwapContext = React.createContext(swapData);
    
export const SwapContextProvider = ({children}: PropsWithChildren<{}>) => {
  const [swapContext, setSwapContext] = useState(swapData);
  return <SwapContext.Provider value={[swapContext, setSwapContext] as any} >{children}</SwapContext.Provider>
}