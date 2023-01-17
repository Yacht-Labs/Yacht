import React, { useEffect, useState } from "react";
import { View, StyleSheet, Text, ScrollView, Image } from "react-native";
import { useHeaderHeight } from '@react-navigation/elements'

export default function SendTokensToSwap() {
    const headerHeight = useHeaderHeight();

    return (
        <View style={[{ paddingTop: headerHeight}, styles.mainContainer]}>
            <Text style={styles.topText}>This transaction will send 100 PLEB tokens to the swap PKP. Once the counterparty sends their 200 BELP tokens to the swap PKP, your swap is ready.</Text>
            <Image style={styles.swapFigure} source={require('../assets/images/swapFigure1.png')} />
            <Text style={styles.bottomText}>If the swap is not completed by the counterparty within 72 hours your tokens will be returned to you.
</Text>        
        </View>
    );
}

const styles = StyleSheet.create({
    mainContainer: {
        flexDirection: 'column'
    },
    topText: {
        paddingHorizontal: 20,
        paddingTop: 100,
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
});