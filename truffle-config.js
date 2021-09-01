const HDWalletProvider = require("truffle-hdwallet-provider");
const { mnemonic, projectId} = require('./secret.json');

module.exports = {

  compilers: {
    solc: {
      version: "^0.8.0"
    }
  },
  
  networks: {
    rinkeby: {
      provider: function() {
        return new HDWalletProvider(mnemonic, `https://rinkeby.infura.io/v3/${projectId}`)
      },
      network_id: "4",       // Rinkeby's id
      gas: 8500000,        
      gasPrice: 1000000000,  // 1 gwei (in wei) (default: 100 gwei)
      confirmations: 2,    // # of confs to wait between deployments. (default: 0)
      timeoutBlocks: 200,  // # of blocks before a deployment times out  (minimum/default: 50)
      skipDryRun: true     // Skip dry run before migrations? (default: false for public nets )
    },
    ropsten: {
      provider: function() {
        return new HDWalletProvider(mnemonic, `https://ropsten.infura.io/v3/${projectId}`)
      },
      network_id: "3",
      gas: 8500000,        
      gasPrice: 1000000000,
    }
  },
  plugins: [
    'truffle-plugin-verify'
  ]
}

