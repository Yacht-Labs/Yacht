import React, { useContext, useEffect, useState } from "react";
import { View, StyleSheet, Text, ScrollView, Image } from "react-native";
import SwapParamCard from "../components/SwapParamCard";
import YachtButton from "../components/YachtButton";
import SelectChainModal from "../components/SelectChainModal";
import { SafeAreaProvider, SafeAreaView } from 'react-native-safe-area-context';
import { useHeaderHeight } from '@react-navigation/elements'
import { useNavigation } from '@react-navigation/native';
import SwapContext from '../context/SwapContext';

export default function CreateLitSwapView() {
    const [chainAParams, setChainAParams] = useState({
      counterPartyAddress: "0xE1b89ef648A6068fb4e7bCd943E3a9f4Dc5c530b",
      chain: "",
      amount: "",
      decimals: "",
      tokenAddress: "",
    });

    const [chainBParams, setChainBParams] = useState({
        counterPartyAddress: "",
        chain: "",
        amount: "",
        decimals: "",
        tokenAddress: "",
    });

    const [modalVisible, setModalVisible] = useState(false);
    const [isSelectingChainA, setIsSelectingChainA] = useState(false);
    const [swapContext, setSwapContext] = useContext(SwapContext);

    const nav = useNavigation();

    async function createSwapPressed() {
        // const response = await fetch('https://api.yachtlabs.io/lit/mintSwapPkp', {
        //     method: 'POST',
        //     headers: {
        //         Accept: 'application/json',
        //         'Content-Type': 'application/json',
        //     },
        //     body: JSON.stringify({
        //         chainAParams,
        //         chainBParams,
        //     }),
        // });
        setSwapContext({ chainAParams, chainBParams })
        nav.navigate('Send Tokens To Swap');
    }

    function specificChainSelected(litChainId: string) {
        isSelectingChainA ? setChainAParams({...chainAParams, chain: litChainId }) : setChainBParams({...chainBParams, chain: litChainId })
        setModalVisible(false);
    }

    function selectChainTouched(isChainA: boolean){
        setIsSelectingChainA(isChainA);
        setModalVisible(true);
    }

    const headerHeight = useHeaderHeight();

    return (
        <SafeAreaView style={[{paddingTop: headerHeight}, styles.mainContainer]}>
            <ScrollView>
                <View style={styles.scrollContainer}>
                    <SwapParamCard params={chainAParams} setParams={setChainAParams} isOrigin={true} onPressChainSelect={() => selectChainTouched(true)} />
                    <View style={styles.arrowContainer}>
                        <Image style={styles.arrow} source={require('../assets/images/LitArrow.png')} />
                    </View>
                    <SwapParamCard params={chainBParams} setParams={setChainBParams} isOrigin={false} onPressChainSelect={() => selectChainTouched(false)}/>
                </View>
            </ScrollView>
            <YachtButton style={styles.button} onPress={() => createSwapPressed()} title={'Create Swap'} />
            <SelectChainModal modalVisible={modalVisible} dismissPressed={() => setModalVisible(false)} onPressSpecificChain={(litChainId: string) => specificChainSelected(litChainId)} />
        </SafeAreaView>
    );
}

const styles = StyleSheet.create({
  scrollContainer: {
    flexDirection: 'column',
  },
  mainContainer: {
    flexDirection: 'column',
    flex: 1,
    marginBottom: 20
  },
  test: {
    fontSize: 50,
  },
  arrow: {
    height: 40,
    width: 40
  },
  arrowContainer: {
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
