enum ErrorTypes {
  BUSINESS_LOGIC = "BusinessLogic",
  UNISWAP_SDK = "UniswapSDK",
  PROVIDER = "Provider",
  LEDGER = "Ledger",
}
export abstract class BridgeError {
  constructor(public message: string, public type: ErrorTypes) {}
}

export class BusinessLogicError extends BridgeError {
  constructor(message: string) {
    super(message, ErrorTypes.BUSINESS_LOGIC);
  }
}

export class UniswapError extends BridgeError {
  constructor(message: string) {
    super(message, ErrorTypes.UNISWAP_SDK);
  }
}

export class ProviderError extends BridgeError {
  constructor(message: string) {
    console.log({ message });
    super(message, ErrorTypes.PROVIDER);
  }
}

export class LedgerError extends BridgeError {
  constructor(message: string) {
    super(message, ErrorTypes.LEDGER);
  }
}
