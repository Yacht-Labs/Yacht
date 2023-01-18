import React, { useEffect, useState, useContext } from "react";
import { View, StyleSheet, Text, ScrollView, Image } from "react-native";
import { SafeAreaProvider, SafeAreaView } from 'react-native-safe-area-context';
import { useHeaderHeight } from '@react-navigation/elements'
import { useNavigation } from '@react-navigation/native';           
import YachtButton from "../components/YachtButton";
import SwapContext from "../context/SwapContext";

export default function SendTokensToSwap() {
    const headerHeight = useHeaderHeight();
    const [swapContext, setSwapContext] = useContext(SwapContext); 
    const nav = useNavigation();

    return (
        <SafeAreaView style={[{ paddingTop: headerHeight}, styles.mainContainer]}>
            <ScrollView style={styles.topContainer}>
                <Text style={styles.topText}>This transaction will send {swapContext.chainAParams.amount} tokens to the swap PKP. Once the counterparty sends their {swapContext.chainBParams.amount} tokens to the swap PKP, your swap is ready.</Text>
                <View style={styles.figureContainer}>
                    <Image style={styles.swapFigure} source={require('../assets/images/swapFigure1.png')} />
                </View>
                <Text style={styles.bottomText}>If the swap is not completed by the counterparty within 72 hours your tokens will be returned to you.
                </Text>      
            </ScrollView>

            <YachtButton onPress={() => nav.navigate('Complete Swap')} style={styles.button} title={'Send'} />
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
        paddingBottom: 20
    },
    bottomText: {
        paddingHorizontal: 20,
        paddingTop: 20,
        fontFamily: 'Akkurat-LightItalic',
        fontSize: 16
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
      }
});