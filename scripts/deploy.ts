import { ethers } from 'hardhat';
import { getDatetimeString } from '../utils/timeUtils';
async function main() {
  const currentTimestampInSeconds = Math.round(Date.now());
  const contractCreatedTime = getDatetimeString(currentTimestampInSeconds)
  const Agenda = await ethers.getContractFactory("Agenda");
  const agenda = await Agenda.deploy("0x40A6ad127e3b4C8077af42a2437cCbd3cdC7609f", "0x5661100D9463c5Df320480a8460d50Dfc39dB9D9");
  await agenda.deployed();

  console.log(
    `${agenda.address} contract is deployed at ${contractCreatedTime}`
  );
  console.log(`
 click this link if you deploy contract on Ethereum Sepolia Testnet
 https://sepolia.etherscan.io/address/${agenda.address} \n
 click this link if you deploy contract on Bianace Smart Chain Testnet
 https://testnet.bscscan.com/address/${agenda.address} \n
 click this link if you deploy contract on Polygon Mumbai Testnet
 https://mumbai.polygonscan.com/address/${agenda.address} \n
  `)
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
