import React, {PropsWithChildren, useState} from 'react';

export interface LitSwapChainParams {
  chainAParams: {
    counterPartyAddress: string;
    chain: string;
    amount: string;
    decimals: string;
    tokenAddress: string;
  },
  chainBParams: {
    counterPartyAddress: string;
    chain: string;
    amount: string;
    decimals: string;
    tokenAddress: string;
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
  },
  chainBParams: {
      counterPartyAddress: "",
      chain: "",
      amount: "",
      decimals: "",
      tokenAddress: "",
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