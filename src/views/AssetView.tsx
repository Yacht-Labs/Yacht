import React, { useEffect } from "react";
import { View, Dimensions } from "react-native";
import TokenCard  from "../components/TokenCard"
import EulerStatusCard from "../components/EulerStatusCard"
import { ethers } from "ethers";

export default function EulerAssetManager() {

  return (
  <View>
    <TokenCard />
    <EulerStatusCard />
  </View>
  );
}
