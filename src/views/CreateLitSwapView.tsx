import React, { useEffect } from "react";
import { View, StyleSheet, Text, ScrollView, Image } from "react-native";
import SwapParamCard from "../components/SwapParamCard";
import YachtButton from "../components/YachtButton";

export default function CreateLitSwapView() {

  return (
    <View style={styles.mainContainer}>
        <ScrollView>
            <View style={styles.scrollContainer}>
                <SwapParamCard isOrigin={true} />
                <View style={styles.arrowContainer}>
                    <Image style={styles.arrow} source={require('../assets/images/LitArrow.png')} />
                </View>
                <SwapParamCard isOrigin={false} />
            </View>
        </ScrollView>
        <YachtButton style={styles.button} type={'info'} title={'Create Swap'} />
    </View>
  );
}

const styles = StyleSheet.create({
  scrollContainer: {
    flexDirection: 'column',
  },
  mainContainer: {
    flexDirection: 'column',
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
    backgroundColor: 'red',
    marginHorizontal: 10,
    marginBottom: 100
  }
});
