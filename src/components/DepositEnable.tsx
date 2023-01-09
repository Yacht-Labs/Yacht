import React from "react";
import { View, StyleSheet, Text } from "react-native";
import YachtButton from "./YachtButton";

export default function DepositEnable() {
    return (
        <View style={styles.container}>
            <View style={styles.titleRow}>
                <Text style={styles.title}>Deposit</Text>
                <Text style={styles.cancel}>Cancel</Text>
            </View>
        </View>
    );
};

const styles = StyleSheet.create({
    container: {
        flexDirection: 'column',
        marginHorizontal: 10,
        marginTop: 18
    },
    titleRow: {
        flexDirection: 'row',
        justifyContent: 'space-between'
    },
    title: {
        fontFamily: 'Akkurat-Bold',
        fontSize: 21,
    },
    cancel: {
        fontFamily: 'Akkurat-Bold',
        fontSize: 14,
        color: '#AD1D1D'
    }
});