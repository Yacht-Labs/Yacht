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
import { serialize } from "@ethersproject/transactions";
import PkpGasCard from "../components/PkpGasCard";

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
    const [checkingStatus, setCheckingStatus] = useState(false);
    const [receiving, setReceiving] = useState(false);
    const [litResponse, setLitResponse] = useState<SwapStatusResponse | undefined>(undefined);
    const [pkpBalance, setPkpBalance] = useState<string>("0");
    const [walletBalance, setWalletBalance] = useState<string>("0");
    const [requiredGas, setRequiredGas] = useState<string>("0");
    const [maxFeePerGas, setMaxFeePerGas] = useState<string>("0");
    const [swapContext, setSwapContext] = useContext(SwapContext); 
    const [sendGasDisabled, setSendGasDisabled] = useState(true);
    const [sendingGas, setSendingGas] = useState(false);

    const symbol = AVAILABLE_CHAINS.find(x => x.litChainId === swapContext.chainBParams.chain)?.symbol;

    const fetchPkpBalance = async () => {
        const bal = await getBalanceOfAddress(swapContext.address);
        const parsed = parseFloat(bal).toFixed(6);
        setPkpBalance(parsed);
    };

    const fetchMaxFeePerGas = async () => {
        const gas = await getMaxFeePerGas();
        setMaxFeePerGas(gas);
    }

    const fetchRequiredGas = async () => {
        const gas = await getRequiredGas();
        const parsedFloat = parseFloat(gas) * 1.5;
        const parsed = parsedFloat.toFixed(6);
        setRequiredGas(parsed);
        setSendGasDisabled(false);
    }

    const fetchWalletBalance = async () => {
        const bal = await getBalanceOfAddress(swapContext.chainAParams.counterPartyAddress);
        const parsed = parseFloat(bal).toFixed(6);
        setWalletBalance(parsed);
    };

    useEffect(() => {
        fetchMaxFeePerGas();
        fetchPkpBalance();
        fetchWalletBalance();
        checkSwapStatus();        
    },[]);

    async function getBalanceOfAddress(address: string): Promise<string> {
        const chainId = AVAILABLE_CHAINS.find(x => x.litChainId === swapContext.chainBParams.chain)?.chainId;
        const provider = getID_TO_PROVIDER(chainId);
        const balance = await provider.getBalance(address);
        const balanceInEth = ethers.utils.formatEther(balance);
        return balanceInEth.toString();
    }

    async function getMaxFeePerGas(): Promise<string> {
        const chainId = AVAILABLE_CHAINS.find(x => x.litChainId === swapContext.chainBParams.chain)?.chainId;
        const provider = getID_TO_PROVIDER(chainId) as ethers.providers.JsonRpcProvider;
        const maxFeePerGas =(await provider.getFeeData()).maxFeePerGas as BigNumber;
        return maxFeePerGas.toString();
    }

    async function getRequiredGas(): Promise<string> {
        const chainId = AVAILABLE_CHAINS.find(x => x.litChainId === swapContext.chainBParams.chain)?.chainId;
        const provider = getID_TO_PROVIDER(chainId) as ethers.providers.JsonRpcProvider;
        const maxFeePerGas =(await provider.getFeeData()).maxFeePerGas as BigNumber;
        const erc20Abi = [
            "function transfer(address to, uint256 value) public returns (bool)",
        ]
        const amount = ethers.utils.parseUnits(swapContext.chainBParams.amount, swapContext.chainBParams.decimals).toString();
        const tokenContract = new ethers.Contract(swapContext.chainBParams.tokenAddress, erc20Abi, provider);
        const transferGasEstimate = await tokenContract.estimateGas.transfer(swapContext.chainAParams.counterPartyAddress, amount, {
            from: swapContext.address,
        })
        console.log(transferGasEstimate.toString());
        const totalGas = (maxFeePerGas.mul(transferGasEstimate).toString());
        console.log(totalGas);
        const formatted = ethers.utils.formatUnits(totalGas, swapContext.chainBParams.decimals) ;
        return formatted;

    }

    async function getSwapStatus(): Promise<SwapStatusResponse> {
        try {
            const body = JSON.stringify({
                pkpPublicKey: swapContext.pkpPublicKey,
                chainAMaxFeePerGas: maxFeePerGas,
                chainBMaxFeePerGas: maxFeePerGas,
            })
            console.log({body})
            const response = await fetch('http://localhost:3000/lit/runLitAction', {
                method: 'POST',
                headers: {
                    Accept: 'application/json',
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify({
                    pkpPublicKey: swapContext.pkpPublicKey,
                    chainAMaxFeePerGas: "44000000001",
                    chainBMaxFeePerGas: "44000000001",
                }),
            });
            //console.log(response)
            const data = await response.json();
            //console.log(data);
            return data;
        } catch(err) {
            console.log({err});
            return { response: 'error', signatures: {} };
        }
    }

    async function checkSwapStatus() {
        setCheckingStatus(true);
        const status = await getSwapStatus();
        if (status.response == 'error' || status.response == 'Conditions for swap not met!') {
            setCheckingStatus(false);
            setSwapIsReady(false);
        } else {
            setCheckingStatus(false);
            console.log(status)
            setLitResponse(status);
            setSwapIsReady(true);
            fetchRequiredGas();
        }
    }

    console.log(litResponse);

    async function sendERC20TokensFromPKP() {
        const provider = getID_TO_PROVIDER(litResponse.response.chainBTransaction.chainId);
        const signedTx = serialize(litResponse.response.chainBTransaction, litResponse.signatures.chainBSignature.signature)
        const tx = await provider.sendTransaction(signedTx);
        console.log({tx});
        const receipt = await tx.wait(1);
        console.log({receipt});
    }

    async function sendGasToPKP() {
        const chainId = AVAILABLE_CHAINS.find(x => x.litChainId === swapContext.chainBParams.chain)?.chainId;
        const provider = getID_TO_PROVIDER(chainId) as ethers.providers.JsonRpcProvider;    
        const wallet = new ethers.Wallet(PRIVATE_KEY, provider);
        const amount = ethers.utils.parseUnits(requiredGas, swapContext.chainBParams.decimals);
        const tx = await wallet.sendTransaction({
            to: swapContext.address,
            value: amount,
        });
        const receipt = await tx.wait(1);
    }

    async function sendGasTouched() {
        setSendingGas(true);
        await sendGasToPKP();
        setSendingGas(false);
        fetchPkpBalance();
    }
    console.log(swapContext);

    return (
        <SafeAreaView style={[{ paddingTop: headerHeight}, styles.mainContainer]}>
            <View style={styles.topArea}>
                <View style={styles.swapStatusContainer}>
                    <View style={styles.swapStatusLeft}>
                        { swapIsReady ? <Image style={styles.swapDot} source={require('../assets/images/SwapReadyDot.png')} /> : <Image style={styles.swapDot} source={require('../assets/images/SwapNotReadyDot.png')} /> }
                        { swapIsReady ? <Text style={styles.swapReadyText}>Swap is Ready</Text> : <Text style={styles.swapReadyText}>Swap is Not Ready</Text> }    
                    </View>
                    <YachtButton onPress={() => checkSwapStatus()} disabled={checkingStatus} fetching={checkingStatus} style={styles.checkStatusButton} title={'Re-Check Status'} textStyle={styles.checkStatusButtonText} />
                </View>
                <View style={styles.figureContainer}>
                    <Image style={styles.swapFigure} source={require('../assets/images/swapFigure2.png')} />
                </View>
                { swapIsReady && <PkpGasCard style={styles.pkpGasCard} symbol={symbol} pkpBalance={pkpBalance} walletBalance={walletBalance} requiredBalance={requiredGas} disabled={sendGasDisabled} sendingGas={sendingGas} onSendGas={() => sendGasTouched()} /> }
            </View>
            <YachtButton onPress={() => sendERC20TokensFromPKP()} disabled={!swapIsReady} style={styles.button} title={'Receive'} />
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