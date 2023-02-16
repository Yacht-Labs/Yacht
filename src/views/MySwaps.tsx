import React, { useContext, useEffect, useState } from "react";
import { View, StyleSheet, Text, FlatList, Dimensions } from "react-native";
import { SafeAreaProvider, SafeAreaView } from "react-native-safe-area-context";
import { useHeaderHeight } from "@react-navigation/elements";
import { SwapContext } from "../context/SwapContext";
import SwapTableCard from "../components/SwapTableCard";
import LottieView from "lottie-react-native";
import { getID_TO_PROVIDER } from "../utils/getProviderByChain";
import { AVAILABLE_CHAINS } from "../constants";
import { ethers } from "ethers";
import { useNavigation } from "@react-navigation/native";
import { ENVIRONMENT, MY_ADDRESS } from "../../env";

// const myAddress = '0x7EbE22f5c45f814B888076cBe6395C8f81fDB026';

const serverDomain =
  ENVIRONMENT === "prod" ? "https://api.yachtlabs.io" : "http://localhost:3000";
console.log(serverDomain);
interface SwapParams {
  counterPartyAddress: string;
  chain: string;
  amount: string;
  decimals: string;
  tokenAddress: string;
}

export interface SwapObject {
  address: string;
  chainAParams: SwapParams;
  chainBParams: SwapParams;
  pkpPublicKey: string;
  ipfsCID: string;
}

export default function MySwaps() {
  const [swapContext, setSwapContext] = useContext(SwapContext);
  const [mySwaps, setMySwaps] = useState<[SwapObject] | []>([]);
  const headerHeight = useHeaderHeight();
  const [loading, setLoading] = useState(false);
  const nav = useNavigation();

  useEffect(() => {
    getMySwaps();
  }, []);

  async function getMySwaps() {
    try {
      const response = await fetch(
        `${serverDomain}/lit/swapObjects/${MY_ADDRESS}`
      );
      console.log(response);
      const data = await response.json();
      setMySwaps(data);
      console.log(data);
    } catch (err) {
      console.log(err);
    }
  }

  async function checkERC20BalanceOfAddress(
    holderAddress: string,
    tokenAddress: string,
    chainId: number
  ): Promise<string> {
    const provider = getID_TO_PROVIDER(chainId);
    const abi = ["function balanceOf(address owner) view returns (uint256)"];
    const contract = new ethers.Contract(tokenAddress, abi, provider);
    const balance = await contract.balanceOf(holderAddress);
    return balance;
  }

  async function handleSwapPressed(swapObject: SwapObject) {
    setLoading(true);
    setSwapContext(swapObject);
    const chainIdA = AVAILABLE_CHAINS.find(
      (x) => x.litChainId === swapObject.chainAParams.chain
    )?.chainId;
    const pkpBalanceA = await checkERC20BalanceOfAddress(
      swapObject.address,
      swapObject.chainAParams.tokenAddress,
      parseInt(chainIdA)
    );
    const pkpBalanceAFormatted = ethers.utils.formatUnits(
      pkpBalanceA,
      parseInt(swapObject.chainAParams.decimals)
    );
    const pkpBalanceAFormattedNumber = parseFloat(pkpBalanceAFormatted);
    if (
      pkpBalanceAFormattedNumber < parseFloat(swapObject.chainAParams.amount)
    ) {
      setLoading(false);
      nav.navigate("Send Tokens To Swap");
      return;
    }
    setLoading(false);
    nav.navigate("Complete Swap");
  }

  return (
    <SafeAreaView style={[styles.container, { marginTop: headerHeight }]}>
      <FlatList
        data={mySwaps}
        renderItem={({ item }) => {
          let originParams: SwapParams;
          let destinationParams: SwapParams;
          if (item.chainAParams.counterPartyAddress === MY_ADDRESS) {
            originParams = item.chainAParams;
            destinationParams = item.chainBParams;
          } else {
            originParams = item.chainBParams;
            destinationParams = item.chainAParams;
          }
          const swapObject: SwapObject = {
            address: item.address,
            chainAParams: originParams,
            chainBParams: destinationParams,
            pkpPublicKey: item.pkpPublicKey,
            ipfsCID: item.ipfsCID,
          };
          return (
            <SwapTableCard
              swapObject={swapObject}
              onPressSwap={(swapObject) => handleSwapPressed(swapObject)}
            />
          );
        }}
        keyExtractor={(item) => item.pkpPublicKey}
      />
      {loading && (
        <View style={styles.animationContainer}>
          <LottieView
            style={styles.chartAnimation}
            source={require("../assets/animations/party.json")}
            autoPlay
            loop
          />
        </View>
      )}
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
  },
  chartAnimation: {
    width: 200,
    height: 200,
  },
  animationContainer: {
    position: "absolute",
    left: 0,
    right: 0,
    height: "100%",
    width: "100%",
    alignItems: "center",
    justifyContent: "center",
  },
});
