const PlayCards = artifacts.require("PlayCards");

module.experts = function(deployer) {
    deployer.deploy(PlayCards, "play cards", "pc", "https://my-json-server.typicode.com/loutus/Truffle-Zeppelin-NFT/Tokens/", 54)
}