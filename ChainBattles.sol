// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Base64.sol";

contract ChainBattles is ERC721URIStorage {
    using Strings for uint256;
    using Counters for Counters.Counter;
    Counters.Counter private _tokenId;

    struct DescribeNft {
        uint256 level;
        uint256 speed;
        uint256 strength;
        uint256 life;
    } 
    mapping(uint256 => DescribeNft) _tokenIdLevels;

    constructor() ERC721("ChainBattles","CB") {

    }

    function random(uint number) public view returns(uint){
        return uint(keccak256(abi.encodePacked(block.timestamp,block.difficulty,  
        msg.sender))) % number;
    }

    function mint() public {
        _tokenId.increment();
        uint256 newItemId = _tokenId.current();
        _safeMint(msg.sender, newItemId);
        DescribeNft memory nft;
        nft.level = 0;
        nft.speed = random(100);
        nft.strength = random(120);
        nft.life = random(140);
        _tokenIdLevels[newItemId] = nft;
        _setTokenURI(newItemId, generateTokenURI(newItemId));
}

    function getLevels(uint256 tokenId) public view returns(string memory) {
        return _tokenIdLevels[tokenId].level.toString();
    }

    function getLives(uint256 tokenId) private view returns(string memory) {
        return _tokenIdLevels[tokenId].life.toString();
    }

    function getStrength(uint256 tokenId) private view returns(string memory) {
        return _tokenIdLevels[tokenId].strength.toString();
    }

    function getSpeed(uint256 tokenId) private view returns(string memory) {
        return _tokenIdLevels[tokenId].speed.toString();
    }

    function generateTokenURI(uint256 tokenId) private view returns(string memory) {
        bytes memory metaData = abi.encodePacked( '{',
            '"name": "Chain Battles #' , tokenId.toString(), '",',
            '"description": "Battles on chain",',
            '"image": "', generateCharacter(tokenId), '"', '}'
        );

        return string(
            abi.encodePacked("data:application/json;base64,",
            Base64.encode(metaData)
            )
            );

    }

    function generateCharacter(uint256 tokenId) public view returns(string memory){

    bytes memory svg = abi.encodePacked(
        '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 350">',
        '<style>.base { fill: white; font-family: serif; font-size: 14px; }</style>',
        '<rect width="100%" height="100%" fill="black" />',
        '<text x="50%" y="40%" class="base" dominant-baseline="middle" text-anchor="middle">',"Warrior",'</text>',
        '<text x="50%" y="50%" class="base" dominant-baseline="middle" text-anchor="middle">', "Levels: ",getLevels(tokenId),'</text>',
        '<text x="50%" y="60%" class="base" dominant-baseline="middle" text-anchor="middle">', "Strength: ",getStrength(tokenId),'</text>',
        '<text x="50%" y="70%" class="base" dominant-baseline="middle" text-anchor="middle">', "Speed: ",getSpeed(tokenId),'</text>',
        '<text x="50%" y="80%" class="base" dominant-baseline="middle" text-anchor="middle">', "Life: ",getLives(tokenId),'</text>',
        '</svg>'
    );
    return string(
        abi.encodePacked(
            "data:image/svg+xml;base64,",
            Base64.encode(svg)
        )   
    );
}

   function train(uint256 tokenId) public {
    require(_exists(tokenId));
    require(ownerOf(tokenId) == msg.sender, "You must own this NFT to train it!");
    uint256 currentLevel = _tokenIdLevels[tokenId].level;
    _tokenIdLevels[tokenId].level = currentLevel + 1;
    _setTokenURI(tokenId, generateTokenURI(tokenId));


   }

}