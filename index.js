import "./polyfill";
import { AppRegistry } from "react-native";
// import LedgerConnect from "./src/LedgerConnect";
// import LedgerAddressSelect from "./src/LedgerAddressSelect";
import EulerAssetManager from "./src/views/AssetView";
import LitSwapNavigator from "./src/navigators/LitYachtSwapNavigator";

// AppRegistry.registerComponent("LedgerConnect", () => LedgerConnect);
// AppRegistry.registerComponent("LedgerAddressSelect", () => LedgerAddressSelect);
AppRegistry.registerComponent("EulerAssetManager", () => EulerAssetManager);
AppRegistry.registerComponent("LitSwapNavigator", () => LitSwapNavigator);
