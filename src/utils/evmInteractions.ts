import { ethers, BigNumber, UnsignedTransaction } from "ethers";
import { getID_TO_PROVIDER } from "./getProviderByChain";
import { PRIVATE_KEY } from "../../env";
import { TransactionReceipt } from "@ethersproject/abstract-provider";
import { serialize, Transaction } from "@ethersproject/transactions";

export interface GasConfig {
  maxFeePerGas: string;
  maxPriorityFeePerGas: string;
  gasLimit: string;
}

export async function getTokenBalanceOfAddress(
  address: string,
  contractAddress: string,
  chainId: number,
  decimals: number
): Promise<string> {
  const provider = getID_TO_PROVIDER(chainId);
  const abi = ["function balanceOf(address owner) view returns (uint256)"];
  const tokenContract = new ethers.Contract(contractAddress, abi, provider);
  const balance = await tokenContract.balanceOf(address);
  const balanceInEth = ethers.utils.formatUnits(balance, decimals);
  return balanceInEth.toString();
}

export async function getNativeBalanceOfAddress(
  address: string,
  chainId: number
): Promise<string> {
  const provider = getID_TO_PROVIDER(chainId);
  const balance = await provider.getBalance(address);
  const balanceInEth = ethers.utils.formatEther(balance);
  return balanceInEth.toString();
}

export async function getGasConfigForERC20Transfer(
  amount: string,
  contractAddress: string,
  to: string,
  from: string,
  decimals: number,
  chainId: number
): Promise<GasConfig> {
  const provider = getID_TO_PROVIDER(
    chainId
  ) as ethers.providers.JsonRpcProvider;
  let fetchedMaxFeePerGas;
  let fetchedMaxPriorityFeePerGas;

  if (chainId === 80001) {
    // mumbai
    const gasPrices = await fetch("https://gasstation-mumbai.matic.today/v2");
    const gasPricesJson = await gasPrices.json();
    fetchedMaxFeePerGas = ethers.utils.parseUnits(
      gasPricesJson.fast.maxFee.toFixed(4).toString(),
      "gwei"
    ) as BigNumber;
    fetchedMaxPriorityFeePerGas = ethers.utils.parseUnits(
      gasPricesJson.fast.maxPriorityFee.toFixed(4).toString(),
      "gwei"
    ) as BigNumber;
  } else if (chainId === 137) {
    // polygon
    const gasPrices = await fetch(
      "https://gasstation-mainnet.matic.network/v2"
    );
    const gasPricesJson = await gasPrices.json();
    fetchedMaxFeePerGas = ethers.utils.parseUnits(
      gasPricesJson.fast.maxFee.toFixed(4).toString(),
      "gwei"
    ) as BigNumber;
    fetchedMaxPriorityFeePerGas = ethers.utils.parseUnits(
      gasPricesJson.fast.maxPriorityFee.toFixed(4).toString(),
      "gwei"
    ) as BigNumber;
  } else {
    const feeData = await provider.getFeeData();
    fetchedMaxFeePerGas = feeData.maxFeePerGas as BigNumber;
    fetchedMaxPriorityFeePerGas = feeData.maxPriorityFeePerGas as BigNumber;
  }

  const erc20Abi = [
    "function transfer(address to, uint256 value) public returns (bool)",
  ];
  const amountInWei = ethers.utils.parseUnits(amount, decimals).toString();
  const tokenContract = new ethers.Contract(
    contractAddress,
    erc20Abi,
    provider
  );
  const transferGasEstimate = await tokenContract.estimateGas.transfer(
    to,
    amountInWei,
    {
      from: from,
    }
  );
  console.log(transferGasEstimate);
  return {
    maxFeePerGas: fetchedMaxFeePerGas.mul(BigNumber.from(2)).toString(),
    maxPriorityFeePerGas: fetchedMaxPriorityFeePerGas.toString(),
    gasLimit: transferGasEstimate.mul(BigNumber.from(2)).toString(),
  };
}

export async function sendNativeCoinToAddress(
  chainId: number,
  toAddress: string,
  amountInWei: BigNumber
): Promise<TransactionReceipt> {
  const provider = getID_TO_PROVIDER(
    chainId
  ) as ethers.providers.JsonRpcProvider;
  const wallet = new ethers.Wallet(PRIVATE_KEY, provider);

  const tx = await wallet.sendTransaction({
    to: toAddress,
    value: amountInWei,
  });
  const receipt = await tx.wait(1);
  return receipt;
}

export async function serializeSignatureAndSendTransaction(
  chainId: number,
  signature: string,
  unsignedTransaction: Transaction
): Promise<TransactionReceipt> {
  const provider = getID_TO_PROVIDER(
    chainId
  ) as ethers.providers.JsonRpcProvider;
  console.log(unsignedTransaction);
  const signedTx = serialize(unsignedTransaction, signature);
  const tx = await provider.sendTransaction(signedTx);
  const receipt = await tx.wait(1);
  return receipt;
}

export async function getERC20Symbol(
  tokenAddress: string,
  chainId: number
): Promise<string> {
  const provider = getID_TO_PROVIDER(
    chainId
  ) as ethers.providers.JsonRpcProvider;
  const contract = new ethers.Contract(
    tokenAddress,
    ["function symbol() view returns (string)"],
    provider
  );
  const symbol = await contract.symbol();
  return symbol;
}

export async function getERC20Decimals(
  tokenAddress: string,
  chainId: number
): Promise<number> {
  const provider = getID_TO_PROVIDER(
    chainId
  ) as ethers.providers.JsonRpcProvider;
  const contract = new ethers.Contract(
    tokenAddress,
    ["function decimals() view returns (uint8)"],
    provider
  );
  const decimals = await contract.decimals();
  return decimals;
}
