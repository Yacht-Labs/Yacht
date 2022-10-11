import React, { Component } from "react";
import { NativeModules, NativeEventEmitter, View } from "react-native";
import TransportBLE from "@ledgerhq/react-native-hw-transport-ble";
import AppEth from "@ledgerhq/hw-app-eth";
import { Device } from "react-native-ble-plx";
import { LedgerError } from "./types";
import { getErrorMessage } from "./utils";



const LedgerBridgeEvents = new NativeEventEmitter(NativeModules.WalletBridge);

class LedgerAddressSelect extends Component {
  state: {
    transport: any;
    eth: AppEth | null;
  } = {
    transport: null,
    eth: null,
  };

  async componentDidMount() {
    LedgerBridgeEvents.addListener(
      "onSendDeviceId",
      async ({
        deviceId,
        accountIndex,
      }: {
        deviceId: Device | string;
        accountIndex: string;
      }) => {
        let payload,
          success = true;
        try {
          if (!this.state.transport || !this.state.eth) {
            const transport = await TransportBLE.open(deviceId);
            
            const eth = new AppEth(transport); // This is the problematic call
            this.setState({
              transport,
              eth,
            });
          }
          const path = "44'/60'/" + accountIndex + "'/0/0"; // HD derivation path
          if (this.state.eth) {
            const { address } = await this.state.eth.getAddress(path);
            payload = {
              address,
              accountIndex,
              path,
            };
          } else {
            throw new Error("Ledger eth not properly set");
          }
        } catch (ledgerError) {
          payload = new LedgerError(getErrorMessage(ledgerError));
          success = false;
        } finally {
          NativeModules.WalletBridge.returnLedgerAccount({
            success,
            payload,
          });
        }
      }
    );
    NativeModules.WalletBridge.returnComponentLoaded();
  }

  render() {
    return <View />;
  }
}

export default LedgerAddressSelect;
