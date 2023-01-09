import React from "react";
import { View, StyleSheet, Text } from "react-native";

export default function EulerStatusCard() {
  return (
    <View style={styles.card}>
        <StatusRow title={"Wallet"} rowColor={"green"} />
        <StatusRow title={"My Supply"} rowColor={"green"} />
        <StatusRow title={"My Debt"} rowColor={"red"} />
    </View>);
}

function StatusRow(props) {
    return (
        <View style={styles.row}>
            <Text style={styles.title}>{props.title}</Text>
            <Text style={[styles.amount, { color: props.rowColor}]}>100 ETH</Text>
            <Text style={[styles.amountUSD, { color: props.rowColor}]}>$1,200</Text>
        </View>
    );
}

const styles = StyleSheet.create({
    card: {
        flexDirection: 'column',
        justifyContent: 'space-evenly',
        height: 100,
        backgroundColor: '#F9FBF2',
        borderColor: '#261201',
        borderWidth: 1,
        borderRadius: 10,
        marginHorizontal: 10,
        marginTop: 10,
        padding: 10
    },
    row: {
        flex: 1,
        flexDirection: 'row',
        justifyContent: 'flex-end',
        alignItems: 'center',
    },
    title: {
        fontFamily: 'Akkurat-Bold',
        fontSize: 18,
        marginRight: 'auto'
    },
    amount: {
        fontFamily: 'Akkurat-Regular',
        fontSize: 18,
    },
    amountUSD: {
        fontFamily: 'Akkurat-LightItalic',
        fontSize: 15,
        paddingLeft: 10
    }
});