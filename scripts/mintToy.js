const { ethers } = require("hardhat");

async function main() {
  const [deployer, user] = await ethers.getSigners();

  // deploy the contract
  const Toy = await ethers.getContractFactory("Toy");
  const toy = await Toy.deploy("Toy Token", "TOY");

  // mint toy tokens as user by sending 1 ETH
  for (i = 0; i < 100; i++) {
    tx = await toy.connect(user).randomEtherToToy({ value: ethers.utils.parseEther("1") });
    const receipt = await tx.wait();

    console.log("Toy tokens minted:", ethers.utils.formatEther(receipt.events[0].args[2]));
  }
}

main()
  .then(() => {
    process.exit(0);
  })
  .catch((e) => {
    console.error(e);
    process.exit(1);
  });
