import React from "react";
import { View, Dimensions } from "react-native";
import TokenCard  from "../components/TokenCard"
import EulerStatusCard from "../components/EulerStatusCard"

export default function EulerAssetManager() {
  return (
  <View>
    <TokenCard />
    <EulerStatusCard />
  </View>
  );
}
