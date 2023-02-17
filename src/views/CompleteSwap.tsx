import React, { useEffect, useState, useContext } from "react";
import { View, StyleSheet, Text, ScrollView, Image } from "react-native";
import { SafeAreaProvider, SafeAreaView } from "react-native-safe-area-context";
import { useHeaderHeight } from "@react-navigation/elements";
import YachtButton from "../components/YachtButton";
import { SwapContext } from "../context/SwapContext";
import { Transaction } from "@ethersproject/transactions";
import { AVAILABLE_CHAINS } from "../constants";
import { getID_TO_PROVIDER } from "../utils/getProviderByChain";
import { ethers, BigNumber, FixedNumber } from "ethers";
import { PRIVATE_KEY } from "../../env";
import { ENVIRONMENT } from "../../env";

const serverDomain =
  ENVIRONMENT === "prod" ? "https://api.yachtlabs.io" : "http://localhost:3000";

import PkpGasCard from "../components/PkpGasCard";
// import { from } from "rxjs";
import {
  getNativeBalanceOfAddress,
  getGasConfigForERC20Transfer,
  GasConfig,
  sendNativeCoinToAddress,
  serializeSignatureAndSendTransaction,
  getERC20Symbol,
  getTokenBalanceOfAddress,
} from "../utils/evmInteractions";

interface LitSignature {
  dataSigned: string;
  publicKey: string;
  r: string;
  recid: number;
  s: string;
  signature: string;
}

interface SwapStatusResponse {
  response:
    | string
    | {
        chainATransaction: Transaction;
        chainBTransaction: Transaction;
      };
  signatures:
    | {}
    | {
        chainASignature: LitSignature;
        chainBSignature: LitSignature;
      };
}

export default function CompleteSwap() {
  const headerHeight = useHeaderHeight();
  const [swapIsReady, setSwapIsReady] = useState(false);
  const [isClawingBack, setIsClawingBack] = useState(false);
  const [statusText, setStatusText] = useState<string>("Swap not ready");
  const [checkingStatus, setCheckingStatus] = useState(false);
  const [receiving, setReceiving] = useState(false);
  const [litResponse, setLitResponse] = useState<
    SwapStatusResponse | undefined
  >(undefined);
  const [pkpBalance, setPkpBalance] = useState<string>("0");
  const [walletBalance, setWalletBalance] = useState<string>("0");
  const [requiredGas, setRequiredGas] = useState<string>("0");
  const [walletSymbol, setWalletSymbol] = useState<string>("");
  const [walletTokenBalance, setWalletTokenBalance] = useState<string>("0");
  const [swapContext, setSwapContext] = useContext(SwapContext);
  const [sendGasDisabled, setSendGasDisabled] = useState(true);
  const [sendingGas, setSendingGas] = useState(false);

  const symbol = isClawingBack
    ? AVAILABLE_CHAINS.find(
        (x) => x.litChainId === swapContext.chainAParams.chain
      )?.symbol
    : AVAILABLE_CHAINS.find(
        (x) => x.litChainId === swapContext.chainBParams.chain
      )?.symbol;

  const fetchWalletSymbol = async (isClawback: boolean) => {
    const chainId = isClawback
      ? AVAILABLE_CHAINS.find(
          (x) => x.litChainId === swapContext.chainAParams.chain
        )?.chainId
      : AVAILABLE_CHAINS.find(
          (x) => x.litChainId === swapContext.chainBParams.chain
        )?.chainId;
    const token = isClawback
      ? swapContext.chainAParams.tokenAddress
      : swapContext.chainBParams.tokenAddress;
    const symbol = await getERC20Symbol(token, chainId);
    setWalletSymbol(symbol);
  };

  const fetchWalletTokenBalance = async (isClawback: boolean) => {
    const chainId = isClawback
      ? AVAILABLE_CHAINS.find(
          (x) => x.litChainId === swapContext.chainAParams.chain
        )?.chainId
      : AVAILABLE_CHAINS.find(
          (x) => x.litChainId === swapContext.chainBParams.chain
        )?.chainId;
    const tokenAddress = isClawback
      ? swapContext.chainAParams.tokenAddress
      : swapContext.chainBParams.tokenAddress;
    const decimals = isClawback
      ? swapContext.chainAParams.decimals
      : swapContext.chainBParams.decimals;
    const bal = await getTokenBalanceOfAddress(
      swapContext.chainAParams.counterPartyAddress,
      tokenAddress,
      chainId,
      decimals
    );
    const parsed = parseFloat(bal).toFixed(3);
    setWalletTokenBalance(parsed);
  };

  const fetchPkpBalance = async (isClawback: boolean) => {
    const chainId = isClawback
      ? AVAILABLE_CHAINS.find(
          (x) => x.litChainId === swapContext.chainAParams.chain
        )?.chainId
      : AVAILABLE_CHAINS.find(
          (x) => x.litChainId === swapContext.chainBParams.chain
        )?.chainId;
    const bal = await getNativeBalanceOfAddress(swapContext.address, chainId);
    const parsed = parseFloat(bal).toFixed(6);
    setPkpBalance(parsed);
  };

  const configRequiredGas = async ({ gasConfig }: { gasConfig: GasConfig }) => {
    const sumGas = BigNumber.from(gasConfig.maxFeePerGas).add(
      BigNumber.from(gasConfig.maxPriorityFeePerGas)
    );
    const totalGas = sumGas
      .mul(BigNumber.from(gasConfig.gasLimit))
      .mul(BigNumber.from(1));
    const parsed = ethers.utils
      .formatUnits(totalGas.toString(), swapContext.chainBParams.decimals)
      .toString();
    const fixed = parseFloat(parsed).toFixed(6);
    setRequiredGas(fixed);
    setSendGasDisabled(false);
  };

  const fetchWalletBalance = async (isClawback: boolean) => {
    const chainId = isClawback
      ? AVAILABLE_CHAINS.find(
          (x) => x.litChainId === swapContext.chainAParams.chain
        )?.chainId
      : AVAILABLE_CHAINS.find(
          (x) => x.litChainId === swapContext.chainBParams.chain
        )?.chainId;
    const bal = await getNativeBalanceOfAddress(
      swapContext.chainAParams.counterPartyAddress,
      chainId
    );
    const parsed = parseFloat(bal).toFixed(6);
    setWalletBalance(parsed);
  };

  useEffect(() => {
    (async () => {
      console.log(swapContext);
      await checkSwapStatus();
      await fetchPkpBalance(isClawingBack);
      await fetchWalletBalance(isClawingBack);
      await fetchWalletSymbol(isClawingBack);
      await fetchWalletTokenBalance(isClawingBack);
    })();
  }, []);

  async function getSwapStatus({
    gasConfig,
  }: {
    gasConfig: GasConfig;
  }): Promise<SwapStatusResponse> {
    try {
      const body = JSON.stringify({
        pkpPublicKey: swapContext.pkpPublicKey,
        chainAGasConfig: {
          maxFeePerGas: gasConfig.maxFeePerGas,
          maxPriorityFeePerGas: gasConfig.maxPriorityFeePerGas,
          gasLimit: gasConfig.gasLimit,
        },
        chainBGasConfig: {
          maxFeePerGas: gasConfig.maxFeePerGas,
          maxPriorityFeePerGas: gasConfig.maxPriorityFeePerGas,
          gasLimit: gasConfig.gasLimit,
        },
      });
      const response = await fetch(`${serverDomain}/lit/runLitAction`, {
        method: "POST",
        headers: {
          Accept: "application/json",
          "Content-Type": "application/json",
        },
        body,
      });
      const data = await response.json();
      return data;
    } catch (err) {
      console.log({ err });
      return { response: "error", signatures: {} };
    }
  }

  async function decodeTransferData(data: string): Promise<[string]> {
    const iface = new ethers.utils.Interface(
      '["function transfer(address to, uint256 value) external returns (bool)"]'
    );
    const decodedData = iface.decodeFunctionData("transfer", data);
    return decodedData as [string];
  }

  async function checkSwapStatus() {
    setCheckingStatus(true);
    const status = await getSwapStatus({
      gasConfig: {
        maxFeePerGas: "0",
        maxPriorityFeePerGas: "0",
        gasLimit: "0",
      },
    });
    if (
      status.response == "error" ||
      status.response == "Conditions for swap not met!"
    ) {
      setCheckingStatus(false);
      setSwapIsReady(false);
      setStatusText("Swap Not Ready");
    } else {
      if (
        status.response.chainATransaction == undefined ||
        status.response.chainBTransaction == undefined
      ) {
        // this means clawback is ready for one counter party
        if (status.response.chainATransaction == undefined) {
          const counterPartyAddress = await decodeTransferData(
            status.response.chainBTransaction.data
          );
          if (
            counterPartyAddress.toLowerCase() ==
            swapContext.chainAParams.counterPartyAddress.toLowerCase()
          ) {
            // this means the Clawback is for the current user
            const amount = ethers.utils.formatUnits(
              decodedData[1],
              status.response.chainBTransaction.decimals
            );
            const gasConfig = await getGasConfigForERC20Transfer(
              amount,
              status.response.chainBTransaction.to,
              decodedData[0],
              swapContext.address,
              status.response.chainBTransaction.decimals,
              status.response.chainBTransaction.chainId
            );
            const gasAdjustedStatus = await getSwapStatus({ gasConfig });
            await fetchWalletSymbol(true);
            await fetchWalletTokenBalance(true);
            await fetchWalletBalance(true);
            await fetchPkpBalance(true);
            setLitResponse(gasAdjustedStatus);
            configRequiredGas({ gasConfig });
            setSwapIsReady(true);
            setStatusText("Clawback Is Ready");
            setIsClawingBack(true);
            setCheckingStatus(false);
          }
        } else {
          const decodedData = await decodeTransferData(
            status.response.chainATransaction.data
          );
          const counterPartyAddress = decodedData[0];
          if (
            counterPartyAddress.toLowerCase() ==
            swapContext.chainAParams.counterPartyAddress.toLowerCase()
          ) {
            // this means the Clawback is for the current user
            const amount = ethers.utils.formatUnits(
              decodedData[1],
              status.response.chainATransaction.decimals
            );

            const gasConfig = await getGasConfigForERC20Transfer(
              amount,
              status.response.chainATransaction.to,
              decodedData[0],
              swapContext.address,
              status.response.chainATransaction.decimals,
              status.response.chainATransaction.chainId
            );
            const gasAdjustedStatus = await getSwapStatus({ gasConfig });
            await fetchWalletSymbol(true);
            await fetchWalletTokenBalance(true);
            await fetchWalletBalance(true);
            await fetchPkpBalance(true);
            setLitResponse(gasAdjustedStatus);
            configRequiredGas({ gasConfig });
            setSwapIsReady(true);
            setStatusText("Clawback Is Ready");
            setIsClawingBack(true);
            setCheckingStatus(false);
          }
        }
      } else {
        // This means swap is ready
        console.log(status);
        const chainId = AVAILABLE_CHAINS.find(
          (x) => x.litChainId === swapContext.chainBParams.chain
        )?.chainId;
        const gasConfig = await getGasConfigForERC20Transfer(
          swapContext.chainBParams.amount,
          swapContext.chainBParams.tokenAddress,
          swapContext.chainAParams.counterPartyAddress,
          swapContext.address,
          swapContext.chainBParams.decimals,
          chainId
        );
        const gasAdjustedStatus = await getSwapStatus({ gasConfig });
        await fetchWalletSymbol(true);
        setLitResponse(gasAdjustedStatus);
        configRequiredGas({ gasConfig });
        setSwapIsReady(true);
        setStatusText("Swap Is Ready");
        setCheckingStatus(false);
      }
    }
  }

  async function sendERC20TokensFromPKP() {
    setReceiving(true);
    let chainId;
    let signature;
    let transaction;
    const decodedData = await decodeTransferData(
      litResponse.response.chainBTransaction.data
    );
    const sendingBTxToCounterParty = decodedData[0];
    if (
      sendingBTxToCounterParty.toLowerCase() ==
      swapContext.chainAParams.counterPartyAddress.toLowerCase()
    ) {
      console.log("working");
      // in this case we know the user is actually the counterparty A so we want the chainB transaction
      chainId = litResponse.response.chainBTransaction.chainId;
      signature = litResponse.signatures.chainBSignature.signature;
      transaction = litResponse.response.chainBTransaction;
    } else {
      // in this case we know the user is actually the counterparty B so we want the chainA transaction
      chainId = litResponse.response.chainATransaction.chainId;
      signature = litResponse.signatures.chainASignature.signature;
      transaction = litResponse.response.chainATransaction;
    }
    const receipt = await serializeSignatureAndSendTransaction(
      chainId,
      signature,
      transaction
    );
    console.log({ receipt });
    await fetchWalletTokenBalance(false);
    setStatusText("Swap Complete");
    setReceiving(false);
  }

  async function sendClawbackERC20TokensFromPKP() {
    setReceiving(true);
    let chainId;
    let signature;
    let transaction;
    if (litResponse.response.chainATransaction == undefined) {
      // in this case we know the user is actually the counterparty B so we want the chainB transaction
      chainId = litResponse.response.chainBTransaction.chainId;
      signature = litResponse.signatures.chainBSignature.signature;
      transaction = litResponse.response.chainBTransaction;
    } else {
      // in this case we know the user is actually the counterparty A so we want the chainA transaction
      chainId = litResponse.response.chainATransaction.chainId;
      signature = litResponse.signatures.chainASignature.signature;
      transaction = litResponse.response.chainATransaction;
    }
    const receipt = await serializeSignatureAndSendTransaction(
      chainId,
      signature,
      transaction
    );
    console.log({ receipt });
    await fetchWalletTokenBalance(true);
    setStatusText("Clawback Complete");
    setReceiving(false);
  }

  async function sendGasTouched() {
    setSendingGas(true);
    const chainId = isClawingBack
      ? AVAILABLE_CHAINS.find(
          (x) => x.litChainId === swapContext.chainAParams.chain
        )?.chainId
      : AVAILABLE_CHAINS.find(
          (x) => x.litChainId === swapContext.chainBParams.chain
        )?.chainId;
    await sendNativeCoinToAddress(
      chainId,
      swapContext.address,
      ethers.utils.parseUnits(requiredGas, swapContext.chainBParams.decimals)
    );
    setSendingGas(false);
    fetchPkpBalance(isClawingBack);
    fetchWalletBalance(isClawingBack);
  }

  return (
    <SafeAreaView style={[{ paddingTop: headerHeight }, styles.mainContainer]}>
      <View style={styles.topArea}>
        <View style={styles.swapStatusContainer}>
          <View style={styles.swapStatusLeft}>
            {swapIsReady ? (
              <Image
                style={styles.swapDot}
                source={require("../assets/images/SwapReadyDot.png")}
              />
            ) : (
              <Image
                style={styles.swapDot}
                source={require("../assets/images/SwapNotReadyDot.png")}
              />
            )}
            <Text style={styles.swapReadyText}>{statusText}</Text>
          </View>
          <YachtButton
            onPress={() => checkSwapStatus()}
            disabled={checkingStatus}
            fetching={checkingStatus}
            style={styles.checkStatusButton}
            title={"Re-Check Status"}
            textStyle={styles.checkStatusButtonText}
          />
        </View>
        <View style={styles.figureContainer}>
          <Image
            style={styles.swapFigure}
            source={require("../assets/images/swapFigure2.png")}
          />
        </View>
        {swapIsReady && (
          <PkpGasCard
            style={styles.pkpGasCard}
            symbol={symbol}
            pkpBalance={pkpBalance}
            walletBalance={walletBalance}
            requiredBalance={requiredGas}
            disabled={sendGasDisabled}
            sendingGas={sendingGas}
            onSendGas={() => sendGasTouched()}
            walletTokenBalance={walletTokenBalance}
            tokenSymbol={walletSymbol}
          />
        )}
      </View>
      <YachtButton
        onPress={() => {
          isClawingBack
            ? sendClawbackERC20TokensFromPKP()
            : sendERC20TokensFromPKP();
        }}
        disabled={!swapIsReady || receiving}
        fetching={receiving}
        style={styles.button}
        title={"Receive"}
      />
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  mainContainer: {
    flexDirection: "column",
    justifyContent: "space-between",
    flex: 1,
    marginBottom: 20,
  },
  swapStatusContainer: {
    flexDirection: "row",
    alignItems: "center",
    justifyContent: "space-between",
    marginLeft: 30,
    marginRight: 20,
  },
  swapStatusLeft: {
    flexDirection: "row",
    justifyContent: "flex-start",
    alignContent: "center",
  },
  swapDot: {
    height: 14,
    width: 14,
  },
  swapReadyText: {
    fontFamily: "Akkurat-Bold",
    fontSize: 20,
    marginLeft: 8,
  },
  checkStatusButton: {
    width: 80,
  },
  checkStatusButtonText: {
    fontFamily: "Akkurat-Bold",
    fontSize: 12,
    color: "#F7701F",
    textAlign: "center",
  },
  swapFigure: {
    height: 320,
    width: 375,
  },
  figureContainer: {
    flexDirection: "row",
    justifyContent: "center",
    marginTop: 20,
    paddingHorizontal: 20,
  },
  topArea: {
    flexDirection: "column",
    justifyContent: "flex-start",
  },
  button: {
    marginTop: 10,
    height: 50,
    backgroundColor: "#FF4F13",
    marginHorizontal: 10,
  },
  pkpGasCard: {
    marginTop: 20,
    marginLeft: 20,
    marginRight: 20,
  },
});
