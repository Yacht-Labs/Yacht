import "./polyfill";
import { AppRegistry } from "react-native";
import LedgerConnect from "./src/LedgerConnect";
import LedgerAddressSelect from "./src/LedgerAddressSelect"

AppRegistry.registerComponent("LedgerConnect", () => LedgerConnect);
AppRegistry.registerComponent("LedgerAddressSelect", () => LedgerAddressSelect);
