// const Transfers = artifacts.require("Transfers");
const Transfers2 = artifacts.require("Transfers2");
module.exports = function (deployer, network, accounts) {
  deployer.then(async () => {
    await deployer.deploy(Transfers2);
  })
}