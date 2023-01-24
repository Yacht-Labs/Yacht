import React, { useEffect, useState, useContext } from "react";
import { View, StyleSheet, Text, ScrollView, Image } from "react-native";
import { SafeAreaProvider, SafeAreaView } from 'react-native-safe-area-context';
import { useHeaderHeight } from '@react-navigation/elements'
import { useNavigation } from '@react-navigation/native';           
import YachtButton from "../components/YachtButton";
import {SwapContext} from "../context/SwapContext";
import Clipboard from '@react-native-clipboard/clipboard';
import { ethers } from "ethers";
import { getID_TO_PROVIDER } from "../utils/getProviderByChain";
import { AVAILABLE_CHAINS } from "../constants";
import { PRIVATE_KEY } from "../../env";

export default function SendTokensToSwap() {
    const headerHeight = useHeaderHeight();
    const [swapContext, setSwapContext] = useContext(SwapContext); 
    const [disableButton, setDisableButton] = useState(false);
    const [fetching, setFetching] = useState(false);
    const nav = useNavigation();
    
    async function sendERC20Tokens() {
        const chainId = AVAILABLE_CHAINS.find(x => x.litChainId === swapContext.chainAParams.chain)?.chainId;
        const provider = getID_TO_PROVIDER(chainId);
        const wallet = new ethers.Wallet(PRIVATE_KEY, provider);
        const contract = new ethers.Contract(swapContext.chainAParams.tokenAddress, [
            "function transfer(address to, uint amount) public returns (bool)"
        ], wallet);
        const amountWei = ethers.utils.parseUnits(swapContext.chainAParams.amount, swapContext.chainAParams.decimals);
        const tx = await contract.transfer(swapContext.address, amountWei);
        console.log(tx);
    }

    async function handleSend() {
        setFetching(true);
        setDisableButton(true);
        await sendERC20Tokens();
        setFetching(false);
        setDisableButton(false);
        nav.navigate('Complete Swap');
    }

    return (
        <SafeAreaView style={[{ paddingTop: headerHeight}, styles.mainContainer]}>
            <ScrollView style={styles.topContainer}>
                <Text style={styles.topText}>This transaction will send {swapContext.chainAParams.amount} tokens to the swap PKP. Once the counterparty sends their {swapContext.chainBParams.amount} tokens to the swap PKP, your swap is ready.</Text>
                <YachtButton onPress={() => Clipboard.setString(swapContext.address)} style={styles.pkpCopyButton} textStyle={styles.pkpCopyButtonText} title={swapContext.address} />
                <View style={styles.figureContainer}>
                    <Image style={styles.swapFigure} source={require('../assets/images/swapFigure1.png')} />
                </View>
                <Text style={styles.bottomText}>If the swap is not completed by the counterparty within 72 hours your tokens will be returned to you.
                </Text>      
            </ScrollView>
            <YachtButton disabled={disableButton} fetching={fetching} onPress={() => handleSend()} style={styles.button} title={'Send'} />
        </SafeAreaView>
    );
}

const styles = StyleSheet.create({
    mainContainer: {
        flexDirection: 'column',
        justifyContent: 'space-between',
        flex: 1,
        marginBottom: 20
    },
    topContainer: {
        flexDirection: 'column'
    },
    topText: {
        paddingHorizontal: 20,
        paddingTop: 30,
        fontFamily: 'Akkurat',
        fontSize: 16,
        paddingBottom: 8
    },
    bottomText: {
        paddingHorizontal: 20,
        paddingTop: 20,
        fontFamily: 'Akkurat-LightItalic',
        fontSize: 16
    },
    pkpCopyButtonText: {
        fontFamily: 'Akkurat',
        fontSize: 12,
    },
    swapFigure: {
        height: 320,
        width: 365
    },
    figureContainer: {
        flexDirection: 'row',
        justifyContent: 'center'
    },
    button: {
        marginTop: 10,
        height: 50,
        backgroundColor: '#FF4F13',
        marginHorizontal: 10,
    },
    pkpCopyButton: {
        marginVertical: 8,
        height: 40,
        backgroundColor: '#78A1BB',
        marginHorizontal: 10,
    }
});