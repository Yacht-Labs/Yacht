import React from "react";
import { View, StyleSheet, Image, Text } from "react-native";

export default function TokenCard() {
  return (
    <View style={styles.card}>
        <View style={styles.leftContainer}>
            <Image style={styles.tokenImage} source={require('../assets/images/USDC.jpg')} />
        </View>
        <View style={styles.middleContainer}>
            <View style={styles.midTopLineContainer}>
                <Text style={styles.symbol}>USDC</Text>
                <Text style={styles.price}>$1.00</Text>
                <View style={styles.tierContainer}>
                    <Text style={styles.tierText}>Collateral</Text>
                </View>
            </View>
            <Text style={styles.name}>US Dollar Coin</Text>
            <Text style={styles.totalSupplyUSD}>Total Supply: $5.2 million</Text>
            <Text style={styles.totalBorrowsUSD}>Total Borrowed: $1.2 million</Text>
        </View>
        <View style={styles.rightContainer}>
            <Text style={styles.supplyApyLabel}>Supply APY</Text>
            <Text style={styles.supplyApy}>2.2%</Text>
            <Text style={styles.borrowApyLabel}>Borrow APY</Text>
            <Text style={styles.borrowApy}>3.5%</Text>
            <View style={styles.eulerApyContainer}>
                <Image style={styles.eulerLogo} source={require('../assets/images/EulerLogo.png')} />
                <Text style={styles.eulerApyText}>22.2%</Text>
            </View>
        </View>
    </View>);
}

const styles = StyleSheet.create({
    card: {
        flexDirection: 'row',
        height: 100,
        backgroundColor: '#F9FBF2',
        borderColor: '#261201',
        borderWidth: 1,
        borderRadius: 10,
        marginHorizontal: 10
    },
    leftContainer: {
        flex: 1,
        alignItems: 'center',
        justifyContent: 'center',
        paddingHorizontal: 6
    },
    middleContainer: {
        flex: 3,
        flexDirection: 'column'
    },
    rightContainer: {
        flex: 1,
        flexDirection: 'column',
        alignItems: 'flex-end',
        padding: 10
    },
    tokenImage: {
        height: 60,
        width: 60,
        borderRadius: 30
    },
    midTopLineContainer: {
        flexDirection: 'row',
        justifyContent: 'flex-start',
        alignContent: 'center',
        flex: 1,
        paddingTop: 10
    },
    symbol: {
        fontFamily: 'Akkurat-Bold',
        fontSize: 18
    },
    price: {
        fontFamily: 'Akkurat-BoldItalic',
        fontSize: 14,
        paddingTop: 2,
        paddingHorizontal: 10
    },
    tierContainer: {
        borderRadius: 4,
        backgroundColor: '#26CDCC',
        alignItems: 'center',
        justifyContent: 'center',
        marginLeft: 'auto',
        marginRight: 10
    },
    tierText: {
        fontFamily: 'Akkurat-Bold',
        fontSize: 12,
        color: 'white',
        paddingHorizontal: 5
    },
    name: {
        flex: 1,
        fontFamily: 'Akkurat-Light',
        fontSize: 16,
        paddingBottom: 4
    },
    totalSupplyUSD: {
        flex: 1,
        fontFamily: 'Akkurat-Regular',
        fontSize: 14
    },
    totalBorrowsUSD: {
        flex: 1,
        fontFamily: 'Akkurat-Regular',
        fontSize: 14,
        paddingBottom: 4
    },
    supplyApyLabel: {
        flex: 1,
        fontFamily: 'Akkurat-Regular',
        fontSize: 12,
    },
    supplyApy: {
        flex: 1,
        fontFamily: 'Akkurat-Bold',
        fontSize: 14,
        color: 'green'
    },
    borrowApyLabel: {
        flex: 1,
        fontFamily: 'Akkurat-Regular',
        fontSize: 12,
    },
    borrowApy: {
        flex: 1,
        fontFamily: 'Akkurat-Bold',
        fontSize: 14,
        color: 'red'
    },
    eulerApyContainer: {
        flex: 1,
        flexDirection: 'row',
        justifyContent: 'flex-end'
    },
    eulerApyText: {
        fontFamily: 'Akkurat-Bold',
        fontSize: 14,
        color: 'green'
    },
    eulerLogo: {
        marginRight: 4,
        height: 12,
        width: 12
    },
});