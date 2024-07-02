# DEGEN TOKEN CONTRACT

This Solidity program is a simple "TOKEN CONTRACT" program that represents the "DegenToken" with the symbol "DGN". It includes functionalities for managing token minting, transferring, redeeming items, burning tokens, and transferring items between players.

## DESCRIPTION

This program is a smart contract written in Solidity, a programming language used for developing smart contracts on the Ethereum blockchain. The contract represents a token named "DegenToken" with the symbol "DGN" and includes functionalities to mint (create), transfer, redeem items, burn (destroy) tokens, and transfer items between players. Additionally, it uses mappings to keep track of the game store items and the items held by each player.

## Getting Started

### Executing Program

To run this program, you can use Remix, an online Solidity IDE. Follow the steps below to get started:

    1. Go to the Remix website at Remix Ethereum IDE.
    2. Create a new file by clicking on the "+" icon in the left-hand sidebar.
    3. Save the file with a .sol extension (e.g., DegenToken.sol).
    4. Copy and paste the following code into the file:

```solidity
//SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract DegenToken is ERC20,Ownable{

    mapping(uint256 => uint256) public gamestoreitems;
    mapping(address => uint256[]) public playerToItems;

    constructor() ERC20("Degen","DGN") Ownable(msg.sender){
        gamestoreitems[1]=100;
        gamestoreitems[2]=40;
        gamestoreitems[3]=120;
        gamestoreitems[4]=130;
        gamestoreitems[5]=20;
    }

    function mintDGNToken(address reciever,uint256 amount) public onlyOwner{
        _mint(reciever,amount);
    }

    function transferDGNToken(address reciever,uint256 amount) public{
        require(balanceOf(msg.sender)>=amount,"Insufficiet Balance");
        transfer(reciever,amount);
    }

    function redeemItems(uint256 item) public{
        require(item>0 && item<=5,"Item Not Found!");
        require(balanceOf(msg.sender)>=gamestoreitems[item],"Insufficient Balance");
        transfer(owner(),gamestoreitems[item]);
        playerToItems[msg.sender].push(item);
    }

    function checkBalance() external view returns (uint256){
        return balanceOf(msg.sender);
    }

    function burnDGNToken(uint256 amount) public{
        require(balanceOf(msg.sender)>=amount,"Insufficient Balance");
        _burn(msg.sender,amount);
    }

    function transferItemToAnotherPlayer(address reciever,uint256 item)public{
        require(item>0 && item<=5,"Item Not Found");
        require(playerToItems[msg.sender].length>0,"No Item To send");
        uint256 size=playerToItems[msg.sender].length;
        bool itemFound=false;
        for(uint256 i=0;i<size;i++){
            if(playerToItems[msg.sender][i]==item){
                itemFound=true;
                playerToItems[msg.sender][i]=playerToItems[msg.sender][size-1];
                playerToItems[msg.sender].pop();

                playerToItems[reciever].push(item);
                break;
            }
        }
        require(itemFound,"You don't have this item");
    }
    function getItemsList(address player) public view returns(uint256[] memory){
        return playerToItems[player];
    }
}

```

### Compiling the Code
    1. Click on the "Solidity Compiler" tab in the left-hand sidebar.
    2. Ensure the "Compiler" option is set to "0.8.20" (or another compatible version).
    3. Click on the "Compile DegenToken.sol" button.

### Deploying the Contract
    1. Go to the "Deploy & Run Transactions" tab in the left-hand sidebar.
    2. Select the "DegenToken" contract from the dropdown menu.
    3. Click on the "Deploy" button.

### Interacting with the Contract
Once the contract is deployed, you can interact with it by calling the various functions (mint, transfer, redeemItems, checkBalance, burn, transferItemToAnotherPlayer, getItemsList).

### Mint Tokens
    1. Select the mintDGNToken function
    2. Enter the receiver address and the amount of tokens to mint.
    3. Click on the "transact" button.
### Transfer Tokens
    1. Select the transferDGNToken function
    2. Enter the receiver address and the amount of tokens to transfer.
    3. Click on the "transact" button.
### Redeem Items
    1. Select the redeemItems function
    2. Enter the item number to redeem.
    3. Click on the "transact" button.
    4. Check Balance
    5. Select the checkBalance function
    6. Click on the "call" button to retrieve the balance of the caller.
### Burn Tokens
    1. Select the burnDGNToken function
    2. Enter the amount of tokens to burn.
    3. Click on the "transact" button.
    4. Transfer Item to Another Player
    5. Select the transferItemToAnotherPlayer function
    6. Enter the receiver address and the item number to transfer.
    7. Click on the "transact" button.
#### Get Items List
    1. Select the getItemsList function
    2. Enter the player address to retrieve the list of items.
    3. Click on the "call" button.

## Deployment to Fuji Testnet
To deploy the contract to the Fuji testnet, follow these steps:

### Install Dependencies

Ensure you have Hardhat and other required dependencies installed:
```bash
npm install --save-dev hardhat @nomicfoundation/hardhat-toolbox @nomiclabs/hardhat-etherscan dotenv
```

### Configure Hardhat
Create or update hardhat.config.js file with the following configuration:

```javascript
require("@nomicfoundation/hardhat-toolbox");
require("dotenv").config();

const { PRIVATE_KEY, SNOWTRACE_API_KEY } = process.env;

module.exports = {
  solidity: "0.8.20",
  networks: {
    fuji: {
      url: 'https://api.avax-test.network/ext/bc/C/rpc',
      accounts: [PRIVATE_KEY],
      chainId: 43113,
    },
  },
  etherscan: {
    apiKey: {
      avalancheFujiTestnet: SNOWTRACE_API_KEY
    },
    customChains: [
      {
        network: "fuji",
        chainId: 43113,
        urls: {
          apiURL: "https://api.snowtrace.io/api",
          browserURL: "https://testnet.snowtrace.io"
        }
      }
    ]
  }
};
```
### Deploy the Contract

Create a scripts/deploy.js file with the following content:

```javascript
async function main() {
  const DegenToken = await ethers.getContractFactory("DegenToken");
  const degenToken = await DegenToken.deploy();
  await degenToken.deployed();
  console.log("DegenToken deployed to:", degenToken.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
```
### Deploy the contract to the Fuji testnet:
```bash
npx hardhat run scripts/deploy.js --network fuji
```
### Verify the Contract
Verify the contract on Snowtrace:
```
npx hardhat verify --network fuji <CONTRACT_ADDRESS>
```

## Authors

Rajeev Singh
[[@rajeevsingh]()](https://www.linkedin.com/in/rajeevsingh2412/)
