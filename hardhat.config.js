require("@nomicfoundation/hardhat-toolbox");
require("hardhat-gas-reporter");

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: {
    version: "0.8.27",
    settings: {
      optimizer: {
        enabled: true,
        runs: 200, // Set the optimizer runs to 200
      },
    },
  },
  gasReporter: {
    enabled: true, // Enable the gas reporter
    currency: "USD", // Display gas costs in USD
    gasPrice: 21, // Specify a custom gas price (in gwei)
    outputFile: "gas-report.txt", // Save report to a file
    noColors: true, // Disable colors (useful for CI)
    token: "ETH", // Use ETH for pricing
    showMethodSig: true, // Show method signature in the report
    outputJSON: true, // Output report in JSON format
  },
};

