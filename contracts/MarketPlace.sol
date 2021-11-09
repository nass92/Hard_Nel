// contracts/GameItem.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Address.sol";
import "./Nelson.sol";

contract MarketPlace {
    using Address for address payable;

    NMToken  private _nmtoken;

    mapping(address => uint256) private _etherBalance;
    
    constructor(address nftAddress_) {
        _nmtoken = NMToken(nftAddress_);
    }

    function buyNFT(uint256 tokenId) public payable {
      //  uint256 etherBalance = msg.sender.balance;
        uint256 price = _nmtoken.getPrice(tokenId);
        
        require(_nmtoken.getApproved(tokenId) == address(this),"SacemEnPLS: Sorry this NFT is not for sell");
        require(msg.value == price, " NMToken : Sorry not enought ethers" );
        require(_nmtoken.isForSell(tokenId) == true, "ee");
        
        address seller = _nmtoken.ownerOf(tokenId);
        payable(seller).transfer(msg.value);
        _nmtoken.transferFrom(seller, msg.sender, tokenId);
        _nmtoken.markAsSold(tokenId);
    }

    function withdraw() public {
        uint256 amount = _etherBalance[msg.sender];
        _etherBalance[msg.sender] = 0;
        payable(msg.sender).sendValue(amount);
    }

    function getEtherBalance() public view returns (uint256) {
        return (msg.sender.balance);
    }
}

