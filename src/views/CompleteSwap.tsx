import React, { useEffect, useState, useContext } from "react";
import { View, StyleSheet, Text, ScrollView, Image } from "react-native";
import { SafeAreaProvider, SafeAreaView } from 'react-native-safe-area-context';
import { useHeaderHeight } from '@react-navigation/elements'
import YachtButton from "../components/YachtButton";
import SwapContext from "../context/SwapContext";

export default function CompleteSwap() {
    const headerHeight = useHeaderHeight();

    return (
        <SafeAreaView style={[{ paddingTop: headerHeight}, styles.mainContainer]}>
            <View style={styles.topArea}>
                <View style={styles.swapStatusContainer}>
                    <View style={styles.swapStatusLeft}>
                        <Image style={styles.swapDot} source={require('../assets/images/SwapNotReadyDot.png')} />
                        <Text style={styles.swapReadyText}>Swap is Not Ready</Text>
                    </View>
                    <Text style={styles.checkStatusButton}>Re-Check Status</Text>
                </View>
                <View style={styles.figureContainer}>
                    <Image style={styles.swapFigure} source={require('../assets/images/swapFigure2.png')} />
                </View>
            
            </View>
            <YachtButton style={styles.button} title={'Receive'} />
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
        marginHorizontal: 30
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
        fontFamily: 'Akkurat-Bold',
        fontSize: 15,
        width: 80,
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
        marginTop: 100,
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
      }
});