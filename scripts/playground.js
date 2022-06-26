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

  console.log(`Signer: ${signer.address}`)
  console.log(`deployer balance: ${await signer.getBalance()}`)

  // We get the contract to deploy
  const DebtFi = await hre.ethers.getContractFactory("DebtFi", signer);
  const { CONTRACT_ADDRESS } = process.env
  if (!CONTRACT_ADDRESS) throw new Error('CONTRACT_ADDRESS not found')
  const contract = DebtFi.attach(CONTRACT_ADDRESS)

  const res = await contract.convertToShares(1000 * 10 ** 6)

  console.log(`res: ${res}`)

  // const OUSDC = await hre.ethers.getContractFactory("OUSDC", signer)
  // const ousdc = OUSDC.attach('0x28419a7401570248E6BE5dDbD4Df73Ca0bE4c1e6')

  // const assetBalance = await ousdc.balanceOf(signer.address)
  // console.log(`Signer's OUSDC balance: ${assetBalance}`)

  // const approval = await ousdc.approve(CONTRACT_ADDRESS, 1000)
  // console.log(`transfer success: ${JSON.stringify(approval)}`)
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
