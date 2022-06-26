require("@nomiclabs/hardhat-waffle");
require("dotenv").config();

// This is a sample Hardhat task. To learn how to create your own go to
// https://hardhat.org/guides/create-task.html
task("accounts", "Prints the list of accounts", async (taskArgs, hre) => {
  const accounts = await hre.ethers.getSigners();

  for (const account of accounts) {
    console.log(account.address);
  }
});

// You need to export an object to set up your config
// Go to https://hardhat.org/config/ to learn more

const { MUMBAI_ENDPOINT, PRIVATE_KEY } = process.env
if (!MUMBAI_ENDPOINT || !PRIVATE_KEY ) throw new Error('env undefined')

/**
 * @type import('hardhat/config').HardhatUserConfig
 */
module.exports = {
  solidity: "0.8.9",
  defaultNetwork: "mumbai",
  networks: {
    mumbai: {
      url: MUMBAI_ENDPOINT,
      accounts: [`0x${PRIVATE_KEY}`]
    }
  }
};
