import * as dotenv from "dotenv";
dotenv.config();

const getStringEnv = (key: string) => {
  const val = process.env[key];
  if (!val) {
    throw new Error(`Environment var ${key} not set`);
  }
  return val;
};

export const GET_PRIVATE_KEY = () => {
  return getStringEnv("PRIVATE_KEY");
};
