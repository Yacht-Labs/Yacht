import React, { useContext, useEffect, useState } from "react";
import { View, StyleSheet, Text, FlatList } from "react-native";
import { SafeAreaProvider, SafeAreaView } from 'react-native-safe-area-context';
import { useHeaderHeight } from '@react-navigation/elements'
import { SwapContext } from '../context/SwapContext';
import SwapTableCard from "../components/SwapTableCard";

// const myAddress = '0x7EbE22f5c45f814B888076cBe6395C8f81fDB026';
const myAddress = '0xE1b89ef648A6068fb4e7bCd943E3a9f4Dc5c530b';

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

    useEffect(() => {
        getMySwaps();
    }, []);

    async function getMySwaps() {
        try {
            const response = await fetch(`http://localhost:3000/lit/swapObjects/${myAddress}`);
            const data = await response.json();
            setMySwaps(data);
            console.log(data);
        } catch(err) {
            console.log(err)
        }
    }

    function handleSwapPressed(swapObject: SwapObject) {
        console.log(swapObject);
    }

    return (
        <SafeAreaView style={[styles.container, {marginTop: headerHeight}]}>
            <FlatList
                data={mySwaps}
                renderItem={({item}) => {
                    let originParams: SwapParams;
                    let destinationParams: SwapParams;
                    if (item.chainAParams.counterPartyAddress === myAddress) {
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
                        ipfsCID: item.ipfsCID
                    }
                    return (
                    <SwapTableCard swapObject={swapObject} onPressSwap={ (swapObject) => handleSwapPressed(swapObject) } />);}}
                        keyExtractor={item => item.pkpPublicKey}
            />
        </SafeAreaView>
    );
}

const styles = StyleSheet.create({
    container: {
        flex: 1,
    },
});