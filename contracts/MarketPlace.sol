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
        uint salePrice = _nmtoken.getPrice(tokenId);
        uint256 amountPaid = msg.value;
        require(msg.value >= salePrice, " NMToken : Sorry not enought ethers" );

        address payable currentOwner = payable(_nmtoken.ownerOf(tokenId));

        currentOwner.transfer(amountPaid);
        _nmtoken.transferFrom(currentOwner, msg.sender, tokenId);
        _nmtoken.markAsSold(tokenId);
        }

    function withdraw() public {
        uint256 amount = _etherBalance[msg.sender];
        _etherBalance[msg.sender] = 0;
        payable(msg.sender).sendValue(amount);
    }

    function getEtherBalance() public view returns (uint256) {
        return (_etherBalance[msg.sender]);
    }
}
