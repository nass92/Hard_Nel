// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol"; 
import "@openzeppelin/contracts/utils/Address.sol";
 

contract NMToken is ERC721URIStorage, ERC721Enumerable,  Ownable {
    using Counters for Counters.Counter;
    using Address for address payable; 
   
    struct Nft {
        string textHashed;
        string txt;
        string title;
        string url;
        string artist;
        bool isForSale;
    }

    
    Counters.Counter private _tokenId;
    Nft[] public list;

    mapping(uint256 => Nft) private _nft;
    mapping(uint256 => address) private _flw;
    mapping(string => uint256) private _cprId;
    mapping(uint256 => uint256) private _price;

    constructor(/*address owner_*/) ERC721("NelsonMakamo", "NM") {
        //transferOwnership(owner_);
    }

   


    /// @dev creation of NFT
    /// @dev this function allow to create nft, 
    /// @dev increment balance[owner], number of id, and total supply.
    
    function certify(

        string memory textHashed,
        string memory txt,
         string memory title,
        string memory url,
        string memory artist,
        bool isForSale, uint256 price_)
        public onlyOwner
        returns (uint256)
    {  
       
        uint256 newNft = _tokenId.current();
        _mint(msg.sender, newNft);
        
        _nft[newNft]= Nft({
            textHashed : textHashed,
            txt: txt,
            title: title,
            url : url,
            artist : artist,
            isForSale: isForSale
        });
        _setTokenURI(newNft, url);
        Nft memory sale = Nft(textHashed,txt,title,url, artist, isForSale);
        if(sale.isForSale == true){
            _price[newNft] = price_;
            list.push(sale);
        }
         _cprId[url] = newNft;
         _tokenId.increment();
        return newNft;
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


  function getPrice(uint256 tokenId) external view returns (uint) {
   return (_price[tokenId]);
  }

  function listNFT(uint256 tokenId) public {
    Nft storage nftForSale = list[tokenId];
    nftForSale.isForSale = true;
  }

function markAsSold(uint256 tokenId) public {
    Nft storage nftForSale = list[tokenId];
    nftForSale.isForSale = false;
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

    /// @dev Recupération data of a nft by his ID 

    function getNMById(uint256 tokenId) public view returns (Nft memory) {
        return _nft[tokenId];
    }
/// @dev Recupération data of a nft by the hash 
   function getNMByHash(string memory textHashed) public view returns (uint256 ) {
        return _cprId[textHashed];
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
