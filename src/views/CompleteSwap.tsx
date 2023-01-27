import React, { useEffect, useState, useContext } from "react";
import { View, StyleSheet, Text, ScrollView, Image } from "react-native";
import { SafeAreaProvider, SafeAreaView } from 'react-native-safe-area-context';
import { useHeaderHeight } from '@react-navigation/elements'
import YachtButton from "../components/YachtButton";
import { SwapContext } from "../context/SwapContext";
import { Transaction } from "@ethersproject/transactions";
import { AVAILABLE_CHAINS } from "../constants";
import { getID_TO_PROVIDER } from "../utils/getProviderByChain";
import { ethers, BigNumber, FixedNumber } from "ethers";
import { PRIVATE_KEY } from "../../env";

import PkpGasCard from "../components/PkpGasCard";
// import { from } from "rxjs";
import { getNativeBalanceOfAddress, getGasConfigForERC20Transfer, GasConfig, sendNativeCoinToAddress, serializeSignatureAndSendTransaction, getERC20Symbol, getTokenBalanceOfAddress } from "../utils/evmInteractions";

interface LitSignature {
    dataSigned: string,
    publicKey: string,
    r: string,
    recid: number,
    s: string,
    signature: string
}

interface SwapStatusResponse {
    response: string | {
        chainATransaction: Transaction
        chainBTransaction: Transaction
    },
    signatures: {} | {
        chainASignature: LitSignature,
        chainBSignature: LitSignature
    },
}

export default function CompleteSwap() {
    const headerHeight = useHeaderHeight();
    const [swapIsReady, setSwapIsReady] = useState(false);
    const [statusText, setStatusText] = useState<string>("Swap not ready");
    const [checkingStatus, setCheckingStatus] = useState(false);
    const [receiving, setReceiving] = useState(false);
    const [litResponse, setLitResponse] = useState<SwapStatusResponse | undefined>(undefined);
    const [pkpBalance, setPkpBalance] = useState<string>("0");
    const [walletBalance, setWalletBalance] = useState<string>("0");
    const [requiredGas, setRequiredGas] = useState<string>("0");
    const [walletSymbol, setWalletSymbol] = useState<string>("");
    const [walletTokenBalance, setWalletTokenBalance] = useState<string>("0");
    const [swapContext, setSwapContext] = useContext(SwapContext); 
    const [sendGasDisabled, setSendGasDisabled] = useState(true);
    const [sendingGas, setSendingGas] = useState(false);

    const symbol = AVAILABLE_CHAINS.find(x => x.litChainId === swapContext.chainBParams.chain)?.symbol;

    const fetchWalletSymbol = async () => {
        const chainId = AVAILABLE_CHAINS.find(x => x.litChainId === swapContext.chainBParams.chain)?.chainId;
        const symbol = await getERC20Symbol(swapContext.chainBParams.tokenAddress, chainId);
        setWalletSymbol(symbol);
    };

    const fetchWalletTokenBalance = async () => {
        const chainId = AVAILABLE_CHAINS.find(x => x.litChainId === swapContext.chainBParams.chain)?.chainId;
        const bal = await getTokenBalanceOfAddress(swapContext.chainAParams.counterPartyAddress, swapContext.chainBParams.tokenAddress, chainId, swapContext.chainBParams.decimals);
        const parsed = parseFloat(bal).toFixed(3);
        setWalletTokenBalance(parsed);
    };

    const fetchPkpBalance = async () => {
        const chainId = AVAILABLE_CHAINS.find(x => x.litChainId === swapContext.chainBParams.chain)?.chainId;
        const bal = await getNativeBalanceOfAddress(swapContext.address, chainId);
        const parsed = parseFloat(bal).toFixed(6);
        setPkpBalance(parsed);
    };

    const configRequiredGas = async ({gasConfig} : {gasConfig: GasConfig}) => {
        const sumGas = BigNumber.from(gasConfig.maxFeePerGas).add(BigNumber.from(gasConfig.maxPriorityFeePerGas));
        const totalGas = sumGas.mul(BigNumber.from(gasConfig.gasLimit)).mul(BigNumber.from(2));
        const parsed = ethers.utils.formatUnits(totalGas.toString(), swapContext.chainBParams.decimals).toString();
        const fixed = parseFloat(parsed).toFixed(6);
        setRequiredGas(fixed);
        setSendGasDisabled(false);
    }

    const fetchWalletBalance = async () => {
        const chainId = AVAILABLE_CHAINS.find(x => x.litChainId === swapContext.chainBParams.chain)?.chainId;
        const bal = await getNativeBalanceOfAddress(swapContext.chainAParams.counterPartyAddress, chainId);
        const parsed = parseFloat(bal).toFixed(6);
        setWalletBalance(parsed);
    };

    useEffect(() => {
        (async () => {
            console.log(swapContext);
            await checkSwapStatus();
            await fetchPkpBalance();
            await fetchWalletBalance();
            await fetchWalletSymbol();
            await fetchWalletTokenBalance();
        })();       
    },[]);

    async function getSwapStatus({gasConfig} : {gasConfig: GasConfig}): Promise<SwapStatusResponse> {
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
                }
            });
            const response = await fetch('http://localhost:3000/lit/runLitAction', {
                method: 'POST',
                headers: {
                    Accept: 'application/json',
                    'Content-Type': 'application/json',
                },
                body,
            });     
            const data = await response.json();
            return data;
        } catch(err) {
            console.log({err});
            return { response: 'error', signatures: {} };
        }
    }

    async function checkSwapStatus() {
        setCheckingStatus(true);
        const status = await getSwapStatus({ gasConfig: { maxFeePerGas: '0', maxPriorityFeePerGas: '0', gasLimit: '0' } });
        if (status.response == 'error' || status.response == 'Conditions for swap not met!') {
            console.log(status)
            setCheckingStatus(false);
            setSwapIsReady(false);
            setStatusText("Swap Not Ready");
        } else {
            setCheckingStatus(false);
            const chainId = AVAILABLE_CHAINS.find(x => x.litChainId === swapContext.chainBParams.chain)?.chainId;
            const gasConfig = await getGasConfigForERC20Transfer(swapContext.chainBParams.amount, swapContext.chainBParams.tokenAddress, swapContext.chainAParams.counterPartyAddress, swapContext.address, swapContext.chainBParams.decimals, chainId);
            const gasAdjustedStatus = await getSwapStatus({gasConfig});
            setLitResponse(gasAdjustedStatus);
            configRequiredGas({gasConfig});
            setSwapIsReady(true);
            setStatusText("Swap Is Ready");
        }
    }

    async function sendERC20TokensFromPKP() {
        setReceiving(true);
        const receipt = await serializeSignatureAndSendTransaction(litResponse.response.chainBTransaction.chainId, litResponse.signatures.chainBSignature.signature, litResponse.response.chainBTransaction);
        console.log({receipt});
        await fetchWalletTokenBalance();
        setStatusText("Swap Complete");
        setReceiving(false);
    }

    async function sendGasTouched() {
        setSendingGas(true);
        const chainId = AVAILABLE_CHAINS.find(x => x.litChainId === swapContext.chainBParams.chain)?.chainId;
        await sendNativeCoinToAddress(chainId, swapContext.address, ethers.utils.parseUnits(requiredGas, swapContext.chainBParams.decimals));
        setSendingGas(false);
        fetchPkpBalance();
        fetchWalletBalance();
    }
    
    console.log(litResponse);
    return (
        <SafeAreaView style={[{ paddingTop: headerHeight}, styles.mainContainer]}>
            <View style={styles.topArea}>
                <View style={styles.swapStatusContainer}>
                    <View style={styles.swapStatusLeft}>
                        { swapIsReady ? <Image style={styles.swapDot} source={require('../assets/images/SwapReadyDot.png')} /> : <Image style={styles.swapDot} source={require('../assets/images/SwapNotReadyDot.png')} /> }
                        <Text style={styles.swapReadyText}>{statusText}</Text>  
                    </View>
                    <YachtButton onPress={() => checkSwapStatus()} disabled={checkingStatus} fetching={checkingStatus} style={styles.checkStatusButton} title={'Re-Check Status'} textStyle={styles.checkStatusButtonText} />
                </View>
                <View style={styles.figureContainer}>
                    <Image style={styles.swapFigure} source={require('../assets/images/swapFigure2.png')} />
                </View>
                { swapIsReady && <PkpGasCard style={styles.pkpGasCard} symbol={symbol} pkpBalance={pkpBalance} walletBalance={walletBalance} requiredBalance={requiredGas} disabled={sendGasDisabled} sendingGas={sendingGas} onSendGas={() => sendGasTouched()} walletTokenBalance={walletTokenBalance} tokenSymbol={walletSymbol} /> }
            </View>
            <YachtButton onPress={() => sendERC20TokensFromPKP()} disabled={!swapIsReady || receiving} fetching={receiving} style={styles.button} title={'Receive'} />
        </SafeAreaView>
    );
};

const styles = StyleSheet.create({
    mainContainer: {
        flexDirection: 'column',
        justifyContent: 'space-between',
        flex: 1,
        marginBottom: 20
    },
    swapStatusContainer: {
        flexDirection: 'row',
        alignItems: 'center',
        justifyContent: 'space-between',
        marginLeft: 30,
        marginRight: 20,
    },
    swapStatusLeft: {
        flexDirection: 'row',
        justifyContent: 'flex-start',
        alignContent: 'center'
    },
    swapDot: {
        height: 14,
        width: 14
    },
    swapReadyText: {
        fontFamily: 'Akkurat-Bold',
        fontSize: 20,
        marginLeft: 8,
    },
    checkStatusButton: {
        width: 80,
    },
    checkStatusButtonText: {
        fontFamily: 'Akkurat-Bold',
        fontSize: 12,
        color: '#F7701F',
       textAlign: 'center'
    },
    swapFigure: {
        height: 320,
        width: 375,     
    },
    figureContainer: {
        flexDirection: 'row',
        justifyContent: 'center',
        marginTop: 20,
        paddingHorizontal: 20
    },
    topArea: {
        flexDirection: 'column',
        justifyContent: 'flex-start'
    },
    button: {
        marginTop: 10,
        height: 50,
        backgroundColor: '#FF4F13',
        marginHorizontal: 10,
    },
    pkpGasCard: {
        marginTop: 20,
        marginLeft: 20,
        marginRight: 20,
    }
});