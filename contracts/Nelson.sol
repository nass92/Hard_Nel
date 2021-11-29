// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol"; 
import "@openzeppelin/contracts/utils/Address.sol";
 import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract NMToken is ERC721, ERC721URIStorage, ERC721Enumerable,  Ownable {
    using Counters for Counters.Counter;
    using Address for address payable; 
   
 Counters.Counter private _tokenId;
    

    struct Nft {
        address authore;
        string title;
        string author;
       string  description;
       string uri; 
       uint256 timestamp;
       bool forSell;
    }
   
    mapping(uint256 => Nft) private _nft;
    mapping(uint256 => address) private _flw;
    mapping(string => uint256) private _cprId;
    mapping(uint256 => uint256) private _price;

    constructor(/*address owner_*/) ERC721("NelsonMakamo", "NM92") {
        //transferOwnership(owner_);
    }

   


    /// @dev creation of NFT
    /// @dev this function allow to create nft, 
    /// @dev increment balance[owner], number of id, and total supply.
    
    function certify(
       string memory title_, string memory author_,
        string memory description_,
        string memory uri_, bool forSell_ )
        public onlyOwner
        returns (uint256)
    {  
        uint256 newNft = _tokenId.current();
        uint256 timestamp = block.timestamp;
        _mint(msg.sender, newNft);
        _nft[newNft]= Nft( msg.sender, title_, author_, description_, uri_, timestamp, forSell_);
        _setTokenURI(newNft, uri_);
         _tokenId.increment();
        return newNft;
    }



  function listNFT(uint256 tokenId, uint256 price_) external {
     _price[tokenId]  = price_;
    Nft storage nftForSale = _nft[tokenId];
    nftForSale.forSell = true;
  }
function markAsSold(uint256 tokenId) public {
    Nft storage nftForSale = _nft[tokenId];
    nftForSale.forSell = false;
  }

    /// @dev Recupération data of a nft by his ID 

    function getNMById(uint256 tokenId) public view returns (Nft memory) {
        return _nft[tokenId];
    }
/// @dev Recupération data of a nft by the hash 
   function getNMByURI(string memory uri) public view returns (uint256) {
        return _cprId[uri];
    }
       function getNMByTitle(string memory title) public view returns (uint256) {
        return _cprId[title];
    }

   function isForSell(uint256 tokenId) public view returns (bool) {
        return _nft[tokenId].forSell;
    }

      function getPrice(uint256 tokenId) external view returns (uint) {
   return (_price[tokenId]);
  }

        /// @dev Utilisation  
    /// @dev With this function, we have acces to the interface of a token */
      function supportsInterface(bytes4 interfaceId)
        public
        view
        virtual
        override(ERC721Enumerable, ERC721)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }


    function _baseURI()
        internal
        view
        virtual
        override(ERC721)
        returns (string memory)
    {
        return "";
    }

    function tokenURI(uint256 tokenId)
        public
        view
        virtual
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }


    function _beforeTokenTransfer(address from, address to, uint256 tokenId)
        internal virtual override (ERC721, ERC721Enumerable)  {
        super._beforeTokenTransfer(from, to, tokenId);
    }


/// @dev This function allow to destroy (burn) a NFT

   function _burn(uint256 tokenId)
        internal
        virtual
        override (ERC721, ERC721URIStorage)
    {
        super._burn(tokenId);
    }

}
