const MToken = artifacts.require("MToken");

module.exports = function (deployer) {
  deployer.deploy(MToken, "MToken", "MTK", "https://mtoken.io/metadata/");
};
