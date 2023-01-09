import React, { useEffect } from "react";
import { View, StyleSheet } from "react-native";
import TokenCard  from "../components/TokenCard"
import EulerStatusCard from "../components/EulerStatusCard"
import { ethers } from "ethers";
import YachtButton from "../components/YachtButton";
import DepositEnable from "../components/DepositEnable";

export default function EulerAssetManager() {

  return (
  <View style={styles.mainContainer}>
    <TokenCard />
    <EulerStatusCard />
    <View style={styles.buttonRow} >
      <YachtButton type={'info'} onPress={() => console.log("Deposit")} title={'Deposit'} />
      <YachtButton type={'info'} onPress={() => console.log("Borrow")} title={'Borrow'} />
    </View>
    <View style={styles.buttonRow} >
      <YachtButton type={'info'} onPress={null} title={'Withdraw'} />
      <YachtButton type={'info'} onPress={null} title={'Repay'} />
    </View>
    <DepositEnable />
  </View>
  );
}

const styles = StyleSheet.create({
  mainContainer: {
    flexDirection: 'column',
  },
  buttonRow: {
    flexDirection: 'row',
    marginHorizontal: 10,
    marginTop: 10,
    height: 50,
    gap: 10
  },

});
