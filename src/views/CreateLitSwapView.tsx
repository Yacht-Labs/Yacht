import React, { useContext, useEffect, useState } from "react";
import { View, StyleSheet, Text, ScrollView, Image } from "react-native";
import SwapParamCard from "../components/SwapParamCard";
import YachtButton from "../components/YachtButton";
import SelectChainModal from "../components/SelectChainModal";
import { SafeAreaProvider, SafeAreaView } from "react-native-safe-area-context";
import { useHeaderHeight } from "@react-navigation/elements";
import { useNavigation } from "@react-navigation/native";
import { SwapContext } from "../context/SwapContext";
import { getERC20Symbol, getERC20Decimals } from "../utils/evmInteractions";
import { AVAILABLE_CHAINS } from "../constants";
import { ENVIRONMENT } from "../../env";

const serverDomain =
  ENVIRONMENT === "prod" ? "https://api.yachtlabs.io" : "http://localhost:3000";

export default function CreateLitSwapView() {
  const [chainAParams, setChainAParams] = useState({
    counterPartyAddress: "0xE1b89ef648A6068fb4e7bCd943E3a9f4Dc5c530b",
    chain: "",
    amount: "",
    decimals: "",
    tokenAddress: "",
    symbol: "",
  });

  const [chainBParams, setChainBParams] = useState({
    counterPartyAddress: "",
    chain: "",
    amount: "",
    decimals: "",
    tokenAddress: "",
    symbol: "",
  });
  const [creatingSwap, setCreatingSwap] = useState(false);
  const [modalVisible, setModalVisible] = useState(false);
  const [isSelectingChainA, setIsSelectingChainA] = useState(false);
  const [swapContext, setSwapContext] = useContext(SwapContext);

  const nav = useNavigation();

  async function createSwapPressed() {
    setCreatingSwap(true);
    try {
      const response = await fetch(`${serverDomain}/lit/mintSwapPkp`, {
        method: "POST",
        headers: {
          Accept: "application/json",
          "Content-Type": "application/json",
        },
        body: JSON.stringify({
          chainAParams,
          chainBParams,
        }),
      });
      const data = await response.json();
      console.log("data: ", data);
      setCreatingSwap(false);
      setSwapContext({ chainAParams, chainBParams, ...data });
      nav.navigate("Send Tokens To Swap");
    } catch (err) {
      console.log("error: ", err);
      console.log("chainA:", chainAParams);
      console.log("chainB:", chainBParams);
      setCreatingSwap(false);
    }
  }

  function specificChainSelected(litChainId: string) {
    isSelectingChainA
      ? setChainAParams({ ...chainAParams, chain: litChainId })
      : setChainBParams({ ...chainBParams, chain: litChainId });
    setModalVisible(false);
  }

  function selectChainTouched(isChainA: boolean) {
    setIsSelectingChainA(isChainA);
    setModalVisible(true);
  }

  async function handleTokenAddressChange(address: string, isChainA: boolean) {
    const chainId = AVAILABLE_CHAINS.find(
      (x) =>
        x.litChainId === (isChainA ? chainAParams.chain : chainBParams.chain)
    )?.chainId;
    const symbol = await getERC20Symbol(address, chainId);
    const decimals = await getERC20Decimals(address, chainId);
    console.log(chainAParams);
    isChainA
      ? setChainAParams({
          ...chainAParams,
          tokenAddress: address,
          symbol: symbol,
          decimals: decimals.toString(),
        })
      : setChainBParams({
          ...chainBParams,
          tokenAddress: address,
          symbol: symbol,
          decimals: decimals.toString(),
        });
  }

  const headerHeight = useHeaderHeight();

  return (
    <SafeAreaView style={[{ paddingTop: headerHeight }, styles.mainContainer]}>
      <ScrollView>
        <View style={styles.scrollContainer}>
          <SwapParamCard
            params={chainAParams}
            setParams={setChainAParams}
            isOrigin={true}
            onPressChainSelect={() => selectChainTouched(true)}
            onChangeTokenAddress={(address) =>
              handleTokenAddressChange(address, true)
            }
          />
          <View style={styles.arrowContainer}>
            <Image
              style={styles.arrow}
              source={require("../assets/images/LitArrow.png")}
            />
          </View>
          <SwapParamCard
            params={chainBParams}
            setParams={setChainBParams}
            isOrigin={false}
            onPressChainSelect={() => selectChainTouched(false)}
            onChangeTokenAddress={(address) =>
              handleTokenAddressChange(address, false)
            }
          />
        </View>
      </ScrollView>
      <YachtButton
        disabled={creatingSwap}
        style={styles.button}
        onPress={() => createSwapPressed()}
        title={"Create Swap"}
        fetching={creatingSwap}
      />
      <SelectChainModal
        modalVisible={modalVisible}
        dismissPressed={() => setModalVisible(false)}
        onPressSpecificChain={(litChainId: string) =>
          specificChainSelected(litChainId)
        }
      />
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  scrollContainer: {
    flexDirection: "column",
  },
  mainContainer: {
    flexDirection: "column",
    flex: 1,
    marginBottom: 20,
  },
  test: {
    fontSize: 50,
  },
  arrow: {
    height: 40,
    width: 40,
  },
  arrowContainer: {
    flexDirection: "row",
    justifyContent: "center",
  },
  button: {
    marginTop: 10,
    height: 50,
    backgroundColor: "#FF4F13",
    marginHorizontal: 10,
  },
});
