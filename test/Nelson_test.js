const { ethers } = require('hardhat');
const { expect } = require('chai');

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
      await nm.connect(deployer).certify('0x4b0e2df202b433cb39d49fe68ebc16734426f4993fdc74b296464191fd51bdb9',
        'ewe', 'rara', 'ipfs.io/ipfs/QmaKPJRAPf9fij2epXWLuQrMGPVWEbK4Fv7RDLwGZcFS3N', 'artist');
      expect(await nm.balanceOf(deployer.address)).to.equal(1);
    });
    it('Should have the right owner', async function () {
      await nm.connect(deployer).certify('0x4b0e2df202b433cb39d49fe68ebc16734426f4993fdc74b296464191fd51bdb9',
        'ewe', 'rara', 'ipfs.io/ipfs/QmaKPJRAPf9fij2epXWLuQrMGPVWEbK4Fv7RDLwGZcFS3N', 'artist');
      expect(await nm.ownerOf(0)).to.equal(deployer.address);
    });

    it('should have the right URI', async function () {
      await nm.connect(deployer).certify('0x4b0e2df202b433cb39d49fe68ebc16734426f4993fdc74b296464191fd51bdb9',
        'ewe', 'rara', 'ipfs.io/ipfs/QmaKPJRAPf9fij2epXWLuQrMGPVWEbK4Fv7RDLwGZcFS3N', 'artist');
      expect(await nm.tokenURI(0)).to.equal('ipfs.io/ipfs/QmaKPJRAPf9fij2epXWLuQrMGPVWEbK4Fv7RDLwGZcFS3N');
    });
  });

  describe('checkin', async () => {
    beforeEach(async function () {
      await nm.connect(deployer).certify('0x4b0e2df202b433cb39d49fe68ebc16734426f4993fdc74b296464191fd51bdb9',
        'ewe', 'rara', 'ipfs.io/ipfs/QmaKPJRAPf9fij2epXWLuQrMGPVWEbK4Fv7RDLwGZcFS3N', 'artist');
    });
    it('Should find the right NFT with his ID', async function () {
      const nft = await nm.connect(deployer).getNMById(0);
      expect('0x4b0e2df202b433cb39d49fe68ebc16734426f4993fdc74b296464191fd51bdb9').to.equal(nft.textHashed);
    });
    it('Should find the right ID with the hash of the content NFT', async function () {
      await nm.connect(deployer).certify('0x4b0e2df202b433cb39d49fe68ebc16734426f4993fdc74b296464191fd51bdb9',
        'ewe', 'rara', 'ipfs.io/ipfs/QmaKPJRAPf9fij2epXWLuQrMGPVWEbK4Fv7RDLwGZcFS3N', 'artist');
      
      expect(await nm.connect(deployer).getNMByHash('0x4b0e2df202b433cb39d49fe68ebc16734426f4993fdc74b296464191fd51bdb9')).to.equal(0);
    });
  });
  describe('getNMById', async () => {
    beforeEach(async function () {
      await nm.connect(deployer).certify('0x4b0e2df202b433cb39d49fe68ebc16734426f4993fdc74b296464191fd51bdb9',
        'ewe', 'rara', 'ipfs.io/ipfs/QmaKPJRAPf9fij2epXWLuQrMGPVWEbK4Fv7RDLwGZcFS3N', 'artist');
    });

    it('Should return the NFT assossiated with the id', async function () {
      const nft = await nm.connect(deployer).getNMById(0);
      expect('0x4b0e2df202b433cb39d49fe68ebc16734426f4993fdc74b296464191fd51bdb9').to.equal(nft.textHashed);
      expect(nft.txt).to.equal('ewe');
      expect(nft.title).to.equal('rara');
      expect(nft.url).to.equal('ipfs.io/ipfs/QmaKPJRAPf9fij2epXWLuQrMGPVWEbK4Fv7RDLwGZcFS3N');
      expect(nft.artist).to.equal('artist');
    });
  });

});
