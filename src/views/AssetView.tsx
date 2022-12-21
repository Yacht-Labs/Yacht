import React from "react";
import { View, Dimensions } from "react-native";
import  TokenCard  from "../components/TokenCard"

export default function EulerAssetManager() {
  const windowWidth = Dimensions.get('window').width;
  console.log(windowWidth)
  return (
  <View>
    <TokenCard />
  </View>
  );
}
