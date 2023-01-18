import React from "react";
import { View, StyleSheet, Text, TouchableOpacity } from "react-native";
import YachtTextInput from "./YachtTextInput";
import { AVAILABLE_CHAINS } from "../constants";
import YachtButton from "./YachtButton";

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
        <YachtButton onPress={onPressChainSelect} title={chainName} style={styles.chainSelectButton}/>
        <YachtTextInput params={params} setParams={setParams} style={styles.input} label={'Token Contract Address'} inputKey={"tokenAddress"} />
        <View style={styles.amountDecimalContainer}>
            <YachtTextInput params={params} setParams={setParams} style={styles.halfInput} label={'Amount'} inputKey={"amount"} />
            <YachtTextInput params={params} setParams={setParams} style={[styles.halfInput, {marginRight: 20 }]} label={'Decimals'} inputKey={"decimals"} />
        </View>
        
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
    },
    halfInput: {
        flex: 1,
        marginLeft: 20,
        marginTop: 16,
        marginBottom: 10
    },
    amountDecimalContainer: {
        flexDirection: 'row',
        justifyContent: 'space-between'
    },
    chainSelectButton: {
        backgroundColor: '#78A1BB',
        marginHorizontal: 20,
        marginTop: 8
    }
});