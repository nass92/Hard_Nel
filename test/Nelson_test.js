const { ethers } = require('hardhat');
const { expect } = require('chai');
const { parseEther } = require('@ethersproject/units');
const {web3} = require('web3');
describe('NelsonTest', function () {
  let deployer, artiste, Nm, nm;

  beforeEach(async function () {
    [, deployer, artiste] = await ethers.getSigners();
    Nm = await ethers.getContractFactory('NMToken');
    nm = await Nm.connect(deployer).deploy();
    await nm.deployed();
  });

  describe('contructor', async () => {
    it('Should have created a NFT contract of name "NelsonMakamo", and Symbol "NM"', async function () {
      expect(await nm.name()).to.equal('NelsonMakamo');
      expect(await nm.symbol()).to.equal('NM');
    });
  });
  describe('certify', async () => {
    beforeEach(async function () {
    });

    it('Should increase the balance of the author', async function () {
      await nm.connect(deployer).certify(
        'ewe', 'rara', 'description', 'ipfs.io/ipfs/QmaKPJRAPf9fij2epXWLuQrMGPVWEbK4Fv7RDLwGZcFS3N', true);
      expect(await nm.balanceOf(deployer.address)).to.equal(1);
    });
    it('Should have the right owner', async function () {
      await nm.connect(deployer).certify(
        'ewe', 'rara', 'description', 'ipfs.io/ipfs/QmaKPJRAPf9fij2epXWLuQrMGPVWEbK4Fv7RDLwGZcFS3N', true);
      expect(await nm.ownerOf(0)).to.equal(deployer.address);
    });

    it('should have the right URI', async function () {
      await nm.connect(deployer).certify(
        'ewe', 'rara', 'description', 'ipfs.io/ipfs/QmaKPJRAPf9fij2epXWLuQrMGPVWEbK4Fv7RDLwGZcFS3N', true);
      expect(await nm.tokenURI(0)).to.equal('ipfs.io/ipfs/QmaKPJRAPf9fij2epXWLuQrMGPVWEbK4Fv7RDLwGZcFS3N');
    });
  });

  describe('checkin', async () => {
    beforeEach(async function () {
      await nm.connect(deployer).certify(
        'ewe', 'rara', 'description', 'ipfs.io/ipfs/QmaKPJRAPf9fij2epXWLuQrMGPVWEbK4Fv7RDLwGZcFS3N', true);
    });
    it('Should find the right NFT with his ID', async function () {
      const nft = await nm.connect(deployer).getNMById(0);
      expect('ewe').to.equal(nft.title);
    });
    it('Should find the right ID with the hash of the content NFT', async function () {
      await nm.connect(deployer).certify(
        'ewe', 'rara', 'description', 'ipfs.io/ipfs/QmaKPJRAPf9fij2epXWLuQrMGPVWEbK4Fv7RDLwGZcFS3N', true);
      
      expect(await nm.connect(deployer).getNMByURI('ipfs.io/ipfs/QmaKPJRAPf9fij2epXWLuQrMGPVWEbK4Fv7RDLwGZcFS3N')).to.equal(0);
    });
  });
  describe('getNMById', async () => {
    beforeEach(async function () {
      await nm.connect(deployer).certify(
        'ewe', 'rara', 'description', 'ipfs.io/ipfs/QmaKPJRAPf9fij2epXWLuQrMGPVWEbK4Fv7RDLwGZcFS3N', true);
      await nm.listNFT(0, 100)
    });
    it('Should return the price of the nft', async function() {
      const nft = await nm.connect(deployer).getPrice(0);
      expect(nft).to.equal(100)
    }) 
    it('Should return the NFT assossiated with the id', async function () {
      const nft = await nm.connect(deployer).getNMById(0);
      expect(nft.title).to.equal('ewe');
      expect(nft.author).to.equal('rara');
      expect(nft.uri).to.equal('ipfs.io/ipfs/QmaKPJRAPf9fij2epXWLuQrMGPVWEbK4Fv7RDLwGZcFS3N');
      expect(nft.description).to.equal('description');
      expect(nft.forSell).to.equal(true);
    });
  });

});

describe('MarketTest', function () {
  

  let MP, mp, deployer, NEW_NFT_OWNER , bob;


  before(async () => {
    [, deployer, artiste, NEW_NFT_OWNER] = await ethers.getSigners();
    
    Nm = await ethers.getContractFactory('NMToken');
    nm = await Nm.connect(deployer).deploy();
    await nm.deployed();
    MarketPlace = await ethers.getContractFactory('MarketPlace');
    mp = await MarketPlace.connect(deployer).deploy(nm.address)
    await mp.deployed();
    
    
    await nm.connect(deployer).certify(
      'ewe', 'rara', 'description', 'ipfs.io/ipfs/QmaKPJRAPf9fij2epXWLuQrMGPVWEbK4Fv7RDLwGZcFS3N', true);
    await nm.connect(deployer).certify(
          'ewe', 'rara', 'description', 'ipfs.io/ipfs/QmaKPJRAPf9fij2epXWLuQrMGPVWEbK4Fv7RDLwGZcFS3N', true);
    await nm.connect(deployer).listNFT(0, 100)
    
  });

  describe('buyNft', () => {
    it('should not allow sale if price is not met', async () => {
      try {
        await mp.buyNFT(0, { from: NEW_NFT_OWNER, value: 200 });
        expect(false);
      } catch (error) {
        expect(error);
      }
    });
    it('buy nft', async () =>{
        await mp.connect(artiste).buyNFT(0);
      expect(await nm.balanceOf(artiste.address)).to.equal(1);
    })
    
    it('should mark item as sold', async () => {
      await nm.listNFT(0, 100)
      const nftSale = await nm.isForSell(0);
      expect(nftSale).to.equal(true);
    });    
  });
});

