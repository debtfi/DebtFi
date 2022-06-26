// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `npx hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
const hre = require("hardhat");

async function main() {
  // Hardhat always runs the compile task when running scripts with its command
  // line interface.
  //
  // If this script is run directly using `node` you may want to call compile
  // manually to make sure everything is compiled
  // await hre.run('compile');

  const [signer] = await hre.ethers.getSigners()

  console.log(`deployer balance: ${await signer.getBalance()}`)

  // We get the contract to deploy
  const DebtFi = await hre.ethers.getContractFactory("DebtFi", signer);
  const { CONTRACT_ADDRESS } = process.env
  if (!CONTRACT_ADDRESS) throw new Error('CONTRACT_ADDRESS not found')
  const contract = DebtFi.attach(CONTRACT_ADDRESS)

  const dcTx = await contract.functions.setDealCreators(['0x4F15bd55BBA6eDf8bc6879Af5f984024f676fB68'])
  const vTx = await contract.functions.setValidators(['0x4F15bd55BBA6eDf8bc6879Af5f984024f676fB68'])

  console.log(`dcTx: ${JSON.stringify(dcTx)}`)
  console.log(`vTx: ${JSON.stringify(vTx)}`)
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
