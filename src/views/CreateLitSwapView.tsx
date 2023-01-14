import React, { useEffect, useState } from "react";
import { View, StyleSheet, Text, ScrollView, Image } from "react-native";
import SwapParamCard from "../components/SwapParamCard";
import YachtButton from "../components/YachtButton";
import SelectChainModal from "../components/SelectChainModal";

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

    async function createSwapPressed() {
        const response = await fetch('https://api.yachtlabs.io/lit/mintSwapPkp', {
            method: 'POST',
            headers: {
                Accept: 'application/json',
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({
                chainAParams,
                chainBParams,
            }),
        });
    }

    function specificChainSelected(litChainId: string) {
        isSelectingChainA ? setChainAParams({...chainAParams, chain: litChainId }) : setChainBParams({...chainBParams, chain: litChainId })
        setModalVisible(false);
    }

    function selectChainTouched(isChainA: boolean){
        setIsSelectingChainA(isChainA);
        setModalVisible(true);
    }

    return (
        <View style={styles.mainContainer}>
            <ScrollView>
                <View style={styles.scrollContainer}>
                    <SwapParamCard params={chainAParams} setParams={setChainAParams} isOrigin={true} onPressChainSelect={() => selectChainTouched(true)} />
                    <View style={styles.arrowContainer}>
                        <Image style={styles.arrow} source={require('../assets/images/LitArrow.png')} />
                    </View>
                    <SwapParamCard params={chainBParams} setParams={setChainBParams} isOrigin={false} onPressChainSelect={() => selectChainTouched(false)}/>
                </View>
            </ScrollView>
            <YachtButton style={styles.button} onPress={createSwapPressed()} title={'Create Swap'} />
            <SelectChainModal modalVisible={modalVisible} dismissPressed={() => setModalVisible(false)} onPressSpecificChain={(litChainId: string) => specificChainSelected(litChainId)} />
        </View>
    );
}

const styles = StyleSheet.create({
  scrollContainer: {
    flexDirection: 'column',
  },
  mainContainer: {
    flexDirection: 'column',
    marginBottom: 100
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
    marginBottom: 200
  }
});
