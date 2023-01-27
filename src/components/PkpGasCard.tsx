import React from "react";
import { View, StyleSheet, Text, StyleProp, ViewStyle } from "react-native";
import YachtButton from "./YachtButton";

interface PkpGasCardProps {
    style: StyleProp<ViewStyle>,
    symbol: string,
    pkpBalance: string,
    requiredBalance: string,
    walletBalance: string,
    onSendGas: () => Promise<void>,
    sendingGas: boolean,
    disabled: boolean,
    tokenSymbol: string,
    walletTokenBalance: string,
}

export default function PkpGasCard({ style, symbol, pkpBalance, requiredBalance, walletBalance, onSendGas, sendingGas, disabled, tokenSymbol, walletTokenBalance }: PkpGasCardProps) {
    return (
        <View style={[styles.container, style]}>
            <View style={styles.pkpGasLeft}>
                <PkpGasRow label={`PKP ${symbol} Balance`} value={pkpBalance} />
                <PkpGasRow label={`PKP ${symbol} Required`} value={requiredBalance} />
                <PkpGasRow label={`Wallet ${symbol} Balance`} value={walletBalance} />
                <PkpGasRow label={`Wallet ${tokenSymbol} Balance`} value={walletTokenBalance} />
            </View>
            <View style={styles.buttonContainer}>
                <YachtButton onPress={onSendGas} disabled={disabled || sendingGas} fetching={sendingGas} style={styles.sendGasButton} textStyle={styles.sendGasButtonText} title={'Send Gas to PKP'} />
            </View>
        </View>
    )
}

function PkpGasRow({ label, value }: { label: string, value: string }) {
    return (
        <View style={styles.pkpGasRow}>
            <Text style={styles.pkpGasText}>{label}</Text>
            <Text style={styles.pkpGasBalanceText}>{value}</Text>
        </View>
    );
}


const styles = StyleSheet.create({
    container: {
        flexDirection: 'row',
        alignItems: 'center',
    },
    pkpGasLeft: {
        flexDirection: 'column',
        flex: 3,
    },
    buttonContainer: {
        flex: 1,
        marginLeft: 30,
    },
    sendGasButton: {
        width: 80
    },
    sendGasButtonText: {
        fontFamily: 'Akkurat-Bold',
        fontSize: 12,
        color: '#F7701F',
        textAlign: 'center'
    },
    pkpGasRow: {
        flexDirection: 'row',
        justifyContent: 'space-between',
        paddingVertical: 4,
    },
    pkpGasText: {
        fontFamily: 'Akkurat-LightItalic',
        fontSize: 15,
    },
    pkpGasBalanceText: {
        fontFamily: 'Akkurat-Bold',
        fontSize: 18,
    }
});