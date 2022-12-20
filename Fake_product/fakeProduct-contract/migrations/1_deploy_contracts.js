var con= artifacts.require("./Fakeproduct2.sol");
var Token = artifacts.require("./Token.sol");

module.exports = async function(deployer) {
  await deployer.deploy(Token, "100");
  const tokeninstance= await Token.deployed();
  
  await deployer.deploy(con, tokeninstance.address);
  const coninstance = await con.deployed();
  await tokeninstance.setAllowedMarketPlace(coninstance.address);
  
}