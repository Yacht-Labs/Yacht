import React, { Component } from "react";
import {
  NativeModules,
  PermissionsAndroid,
  Platform,
  View,
} from "react-native";
import { Observable, Subscription } from "rxjs";
import TransportBLE from "@ledgerhq/react-native-hw-transport-ble";
import { Device } from "@ledgerhq/react-native-hw-transport-ble/lib/types";

// This is helpful if you want to see BLE logs. (only to use in dev mode)

class LedgerConnect extends Component {
  state: {
    error: any;
    refreshing: boolean;
    sub: Subscription | null;
  } = {
    error: null,
    refreshing: false,
    sub: null,
  };

  async componentDidMount() {
    // NB: this is the bare minimal. We recommend to implement a screen to explain to user.
    if (Platform.OS === "android") {
      await PermissionsAndroid.request(
        PermissionsAndroid.PERMISSIONS.ACCESS_COARSE_LOCATION
      );
    }
    let previousAvailable = false;
    const sub = new Observable(TransportBLE.observeState).subscribe(
      (e: any) => {
        if (e.available !== previousAvailable) {
          previousAvailable = e.available;
          if (e.available) {
            this.reload();
          }
        }
      }
    );
    this.setState({ sub });
    this.startScan();
  }

  componentWillUnmount() {
    this.state.sub?.unsubscribe();
  }

  startScan = async () => {
    this.setState({ refreshing: true });
    const sub = new Observable(TransportBLE.listen).subscribe({
      complete: () => {
        this.setState({ refreshing: false });
      },
      next: (e: any) => {
        if (e.type === "add") {
          NativeModules.WalletBridge.returnLedgerDevice({
            success: true,
            payload: e,
          });
        }
        // NB there is no "remove" case in BLE.
      },
      error: (error) => {
        this.setState({ error, refreshing: false });
        this.reload();
      },
    });
    this.setState({
      sub,
    });
  };

  reload = async () => {
    this.state.sub?.unsubscribe();
    this.setState({ error: null, refreshing: false });
    this.startScan();
  };

  render() {
    return <View />;
  }
}

export default LedgerConnect;
