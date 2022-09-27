const HDWalletProvider = require('truffle-hdwallet-provider')
require('dotenv').config()


module.exports = {
  networks: {
    development: {
      host: "127.0.0.1",
      port: 7545,
      network_id: "5777"
    },
    bsctestnet: {
      provider: () => new HDWalletProvider(process.env.MNEMONIC, `https://data-seed-prebsc-1-s1.binance.org:8545`),
      network_id: 97,
      confirmations: 10,
      timeoutBlocks: 200,
      skipDryRun: true
    },
    bsc: {
      provider: () => new HDWalletProvider(process.env.MNEMONIC, `https://bsc-dataseed1.binance.org`),
      network_id: 56,
      confirmations: 10,
      timeoutBlocks: 200,
      skipDryRun: true
    },
    rinkeby: {
      provider: () => new HDWalletProvider(process.env.MNEMONIC, "https://rinkeby.infura.io/v3/4c4d7058f1b94e91bdfb6c88ad41eb68"),
      network_id: "*"
    },
    ethereum: {
      provider: () => new HDWalletProvider(process.env.MNEMONIC, "https://mainnet.infura.io/v3/4c4d7058f1b94e91bdfb6c88ad41eb68"),
      network_id: 1
    }
  },

  compilers: {
    solc: {
      version: "^0.8.0",
      optimizer: {
        enabled: true,
        runs: 200
      }
    }
  },
  plugins: ['truffle-plugin-verify'],
  api_keys: {
    bscscan: 'EXWKZHKNPNUAF5SDZ48YFEZRPGGJY3FPQ7',
    etherscan: '9FM6WF4FW6EVYZ4KRIY1T2EXFQGUVCNP9A'
  }
};