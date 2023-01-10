import React from "react";
import { View, StyleSheet, Text, TouchableOpacity } from "react-native";
import YachtTextInput from "./YachtTextInput";

export default function SwapParamCard({ onPressChainSelect, isOrigin }) {
    return (
      <View style={styles.card}>
        <Text style={styles.heading}>{ isOrigin ? 'ORIGIN ' : 'DESTINATION'}</Text>
        <TouchableOpacity 
            onPress={onPressChainSelect} 
            activeOpacity={0.8} >
            <Text style={styles.chainSelect}>Select Chain</Text>
        </TouchableOpacity>
        <YachtTextInput style={styles.input} label={'Token Address'} />
        <YachtTextInput style={styles.input} label={'Amount'} />
        { !isOrigin && <YachtTextInput style={styles.input} label={'Recipient Address'} />}
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