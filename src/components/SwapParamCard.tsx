import React from "react";
import { View, StyleSheet, Text, TouchableOpacity } from "react-native";
import YachtTextInput from "./YachtTextInput";
import { AVAILABLE_CHAINS } from "../constants";

export default function SwapParamCard({ onPressChainSelect, isOrigin, params, setParams }) {
    let chainName;
    if(params.chain === '') {
        chainName = 'Select Chain';
    } else {
        const chainObj = AVAILABLE_CHAINS.find(x => x.litChainId === params.chain)
        chainName = chainObj?.label;
    }

    return (
      <View style={styles.card}>
        <Text style={styles.heading}>{ isOrigin ? 'ORIGIN ' : 'DESTINATION'}</Text>
        <TouchableOpacity 
            onPress={onPressChainSelect} 
            activeOpacity={0.8} >
            <Text style={styles.chainSelect}>{chainName}</Text>
        </TouchableOpacity>
        <YachtTextInput params={params} setParams={setParams} style={styles.input} label={'Token Contract Address'} inputKey={"tokenAddress"} />
        <YachtTextInput params={params} setParams={setParams} style={styles.input} label={'Amount'} inputKey={"amount"} />
        { !isOrigin && <YachtTextInput params={params} setParams={setParams} style={styles.input} label={'Recipient Address'} inputKey={"counterPartyAddress"}/>}
      </View>);
}

const styles = StyleSheet.create({
    card: {
        flexDirection: 'column',
        borderColor: '#FEC719',
        borderWidth: 1,
        borderRadius: 12,
        marginHorizontal: 10,
        padding: 10
    },
    heading: {
        fontFamily: 'Akkurat-Bold',
        fontSize: 20,
        marginTop: 8,
        marginLeft: 12,
        height: 26
    },
    chainSelect: {
        fontFamily: 'Akkurat',
        fontSize: 20,
        color: '#D0021B',
        marginTop: 12,
        marginLeft: 20
    },
    input: {
        marginTop: 16,
        marginHorizontal: 20
    }
});