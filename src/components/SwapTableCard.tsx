import React from "react";
import { View, StyleSheet, Text, StyleProp, ViewStyle, TouchableOpacity } from "react-native";
import { useEffect, useState } from "react";
import { AVAILABLE_CHAINS } from "../constants";
import { getID_TO_PROVIDER } from "../utils/getProviderByChain";
import { ethers } from "ethers";
import { LitSwapChainParams, PKPInfo } from "../context/SwapContext";
import { SwapObject } from "../views/MySwaps"; 
import { getERC20Symbol } from "../utils/evmInteractions";

interface SwapTableCardProps {
    swapObject: SwapObject;
    onPressSwap: (swapObject: SwapObject) => void;
}

export default function SwapTableCard({ swapObject, onPressSwap }: SwapTableCardProps) {
    const [originSymbol, setOriginSymbol] = useState<string>('');
    const [destinationSymbol, setDestinationSymbol] = useState<string>('');
    
    useEffect(() => {
        async function getSymbols() {
            const chainIdA = AVAILABLE_CHAINS.find(x => x.litChainId === swapObject.chainAParams.chain)?.chainId;
            const chainIdB = AVAILABLE_CHAINS.find(x => x.litChainId === swapObject.chainBParams.chain)?.chainId;
            const originSymbol = await getERC20Symbol(swapObject.chainAParams.tokenAddress, chainIdA);
            const destinationSymbol = await getERC20Symbol(swapObject.chainBParams.tokenAddress, chainIdB);
            setOriginSymbol(originSymbol);
            setDestinationSymbol(destinationSymbol);
        }
        getSymbols();
    }, []);

    return (
        <TouchableOpacity 
        onPress={() => onPressSwap(swapObject)} 
        activeOpacity={0.8} >
            <View style={styles.container}>
                <SwapRow label={'Sending:'} value={swapObject.chainAParams.amount} network={swapObject.chainAParams.chain} symbol={originSymbol} />
                <SwapRow label={'Receiving:'} value={swapObject.chainBParams.amount} network={swapObject.chainBParams.chain} symbol={destinationSymbol} />
                <View style={styles.infoRow}>
                    <Text style={styles.labelText}>Counterparty:</Text>
                    <Text style={styles.counterpartyText}>{swapObject.chainBParams.counterPartyAddress}</Text>
                </View>
            </View>
        </TouchableOpacity>
    )
}

function SwapRow({ label, value, network, symbol }: { label: string, value: string, network: string, symbol: string }) {
    return (
        <View style={styles.infoRow}>
            <View style={styles.infoRowLeft}>
                <Text style={styles.labelText}>{label}</Text>
                <Text style={styles.valueText}>{value}</Text>
                <Text style={styles.symbolText}>{symbol}</Text>
            </View>
            <Text style={styles.networkText}>{network}</Text>
        </View>
    );
}

const styles = StyleSheet.create({
    container: {
        flexDirection: 'column',
        marginTop: 10,
        marginHorizontal: 20,
        backgroundColor: '#F5F5F5',
        padding: 10,
        borderRadius: 10,
    },
    infoRow: {
        flexDirection: 'row',
        justifyContent: 'space-between',
        marginTop: 4,
        alignItems: 'center',
    },
    infoRowLeft: {
        flexDirection: 'row',
        justifyContent: 'flex-start',
        alignItems: 'center',
    },
    labelText: {
        fontFamily: 'Akkurat-Bold',
        fontSize: 15,
        marginRight: 10,
    },
    valueText: {
        fontFamily: 'Akkurat',
        fontSize: 12,
    },
    networkText: {
        fontFamily: 'Akkurat-LightItalic',
        fontSize: 12,
    },
    counterpartyText: {
        fontFamily: 'Akkurat',
        fontSize: 9,
    },
    symbolText: {
        fontFamily: 'Akkurat',
        fontSize: 12,
        marginLeft: 5,
    }
});