## Installation

Si vous voulez Cloner ce projet, copiez collez ces commandes sur votre terminal :
git clone https://github.com/    cd    .

Pour compiler et tester les contrats, exécuter ces commandes sur votre terminal :

yarn 
npx hardhat compile
npx hardhat test

# Enoncé
L'objectif de ce projet est de pouvoir créer des NFTs de vidéo. J'ai alors créé un Contrat, qui prend différents paramettre et fonctions. 

Dans ce projet, 

# Contract

## OpenZeppelin 

Dans la construction du smart-contract, j'utilise les contrats d'openZeppelin, afin de faciliter les procédés et l'utilisation de certaines fonctions.

Le contrat Ownable, permet de restreindre certains accés à une seule personne (ex: owner du contrat, ou owner du token...).
Ou encore le contrat ERC721Enumerable, qui est une interface optionnelle pour ajouter plus de fonctionnalités à l'ERC721 NFT; comme la fonction tokenByIndex(index).

## Struct 
Avant toute déclaration de fonction, il convient de définir la structure de notre NFT. La structure permet de déclarer toutes les données utiles à représenter dans notre NFT.
Dans notre NFT, il serait intéressant d'y inscrire un titre, le nom de l'artiste, un texte descriptif, et bien évidemment l'adresse de la vidéo.

      struct Nft {
        string textHashed;
        string txt;
        string title;
        string url;
        string artist;
    }





## Function Certify :

La fonction Certify, est la fonction principale de notre smart-contract. C'est elle qui permet la création de nos NFTs. Elle prend en paramettre notre struct et est définie comme onlyOwner. Elle peut donc être appelée uniquement par celui qui déploie (ou détient) le smart-contract.

Lorsque cette fonction est appelée; c'est grâce à la fonction '_mint' que le nft est créé. Puis grâce au '_setTokenURI' associe l'url a l'id du nft.

    function certify(

        string memory textHashed,
        string memory txt,
         string memory title,
        string memory url,
        string memory artist)
        public onlyOwner
        returns (uint256)
    {  
       
        uint256 newNft = _nftId.current();
        _mint(msg.sender, newNft);
        
        _nft[newNft]= Nft({
            textHashed : textHashed,
            txt: txt,
            title: title,
            url : url,
            artist : artist
        });
        _nftId.increment();
        _setTokenURI(newNft, url);
        //_cprId[NonFungibleToken.textHashed] = newNft;
        return newNft;
    }

## URL et PINATA : 

Pinata permet le stockage de données,tel que des images, des vidéos,ou encore des dossiers/fichiers.
Ces données sont stockées sur IPFS,qui est un réseau de stockage décentralisée.
En implémentant sur ipfs, le fichier est alors associé à une adresse CID,qui n'est ni plus ni moins l'adresse du fichier.
Dans ce projet, nous utilisons ipfs, afin de rendre le plus décentralisée possible.

# Hardhat 

## qu'est ce que c'est: 
HardHat est un Ethereum development environment pour professionals. Hardat est qualifié de:

Flexible: On peut tout utilisé  ou juste une partie de Hardhat selon nos besoins.
Extensible: Hardhat utilise un système de plugins que l'on peut importer en fonction de nos besoins.
Fast: Accélère le processus de développement, automatise certaines tâches et leur noeud local utilisé pour effectuer nos tests, le Hardhat network est bien plus rapide à exécuter nos transactions qu'une instance de ganache.
Hardhat est utilisable via la ligne de commande.
Nous y exécutons des tasks, certaines sont fournies par défaut, d'autres viennent de plugins que nous devrons installer (via yarn toujours).
Les tasks les plus communs sont la compilation de nos smart contrats, l'exécution de scripts de tests ou de déploiements.

Les tasks sont toutes les fonctionnalités que vous offre le client Hardhat.
Les tasks les plus communs sont accessibles par défaut.

    ```shell
    npx hardhat accounts => affiche l'addresse, balance...
    npx hardhat compile => compile les smart-contracts
    npx hardhat clean  => netoie le cache artifact
    npx hardhat test => lance les test unitaires
    npx hardhat help 
    ```
## Hardhat.config

La configuration d'hardhat ce fait dans ce fichier. Ici nous définissons par exemple la version solidity utilisée dans le compilateur. Mais également les différents réseaux pour deployer; avec les éléments permettant de récupérer les identifiants (infura ici) de connexions à la blockchain.

    require('dotenv').config()
    const INFURA_PROJECT_ID = process.env.INFURA_PROJECT_ID
    const DEPLOYER_PRIVATE_KEY = process.env.DEPLOYER_PRIVATE_KEY



        module.exports = {
    solidity: "0.8.4",
    docgen: {
        path: './docs',
        clear: true,
        runOnCompile: true,
    },
    networks: {
        mainnet: {
        url: `https://mainnet.infura.io/v3/${INFURA_PROJECT_ID}`,
        accounts: [`0x${DEPLOYER_PRIVATE_KEY}`],
        },
        ropsten: {
        url: `https://ropsten.infura.io/v3/${INFURA_PROJECT_ID}`,
        accounts: [`0x${DEPLOYER_PRIVATE_KEY}`],
        },
        kovan: {
        url: `https://kovan.infura.io/v3/${INFURA_PROJECT_ID}`,
        accounts: [`0x${DEPLOYER_PRIVATE_KEY}`],
        },
        rinkeby: {
        url: `https://rinkeby.infura.io/v3/${INFURA_PROJECT_ID}`,
        accounts: [`0x${DEPLOYER_PRIVATE_KEY}`],
        },
        goerli: {
        url: `https://goerli.infura.io/v3/${INFURA_PROJECT_ID}`,
        accounts: [`0x${DEPLOYER_PRIVATE_KEY}`],
        },},};




## Librairies and plugins :

ethers.js, waffle, chai

## hardhat-docgen : 

hardhat-docgen nous permet de générer de la documentation depuis nos commentaires NatSpec. Installer hardhat-docgen:


