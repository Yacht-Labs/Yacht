import React, { useEffect, useState, useContext } from "react";
import { View, StyleSheet, Text, ScrollView, Image } from "react-native";
import { SafeAreaProvider, SafeAreaView } from 'react-native-safe-area-context';
import { useHeaderHeight } from '@react-navigation/elements'
import YachtButton from "../components/YachtButton";
import { SwapContext } from "../context/SwapContext";

export default function CompleteSwap() {
    const headerHeight = useHeaderHeight();
    const [swapIsReady, setSwapIsReady] = useState(false);
    const [checkingStatus, setCheckingStatus] = useState(false);
    const [receiving, setReceiving] = useState(false);
    const [swapContext, setSwapContext] = useContext(SwapContext); 

    async function checkSwapStatus() {
        //console.log(swapContext);
        setCheckingStatus(true);
        try {
            const response = await fetch('https://api.yachtlabs.io/lit/runLitAction', {
                method: 'POST',
                headers: {
                    Accept: 'application/json',
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify({
                    pkpPublicKey: swapContext.publicKey,
                }),
            });
            const data = await response.json();
            console.log(data);
            console.log(response);
            setCheckingStatus(false);
        } catch(err) {
            console.log(err)
            setCheckingStatus(false);
        }
    }

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
            
            </View>
            <YachtButton disabled={swapIsReady} style={styles.button} title={'Receive'} />
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