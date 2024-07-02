
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
