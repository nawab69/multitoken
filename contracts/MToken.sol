// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";


/// @title A contract with both Fungible and NON Fungible collection
/// @author nawab69
/// @dev 
///     - tokenID 0 is for Fungible token
///     - Fungible token can be mint by only owner / deployer of this contract by calling mintGold function
///     - From token ID 1 to ... , All tokens are non Fungible with single or multiple supply
///     - It can be mint by calling mint Function and the amount in the parameters

contract MToken is ERC1155, Ownable {

    constructor(
        string memory _name,
        string memory _symbol, 
        string memory _baseUri
        ) ERC1155(_baseUri) 
        {
        name = _name;
        symbol = _symbol;
        baseUri = _baseUri;
    }

    enum Rarity {
        COMMON,
        UNCOMMON,
        RARE,
        UNIQUE
    }

    uint constant GOLD = 0;

    string public name;
    string public symbol; 
    uint256 public tokenCount = 1;
    string public baseUri;
    
    mapping(uint => string) private tokenURI;
    

    /// @notice Mint X token of y (amount) supply
    /// @dev mint NFT token with y amount supply
    /// @param amount is a parameter of supply
    function mint(
        uint256 amount
        ) public 
        onlyOwner
    {
        tokenCount += 1;
        _mint(msg.sender,
        tokenCount,
        amount,
        "");
    }

    /// @notice Mint X token of y (amount) supply and add custom token URI
    /// @param amount a parameter with y supply
    /// @param _tokenURI a parameter of token metadata URI
    function mintWithUri(
        uint256 amount, 
        string memory _tokenURI
        ) public 
        onlyOwner
    {
        tokenCount += 1;
        _mint(msg.sender, 
        tokenCount, 
        amount, 
        "");
        tokenURI[tokenCount] = _tokenURI;
    }

    /// @notice Mint X token of y (amount) supply and add custom token URI
    /// @param _rarity a parameter with rarity [0 = common, 1 = uncommon, 2 = rare, 3 = unique]
    /// @param _tokenURI a parameter of token metadata URI
    function mintByRarity(
        Rarity _rarity, 
        string memory _tokenURI
        ) public 
        onlyOwner
    {
        tokenCount += 1;
        _mint(msg.sender, 
        tokenCount, 
        getSupplyByRarity(_rarity), 
        "");
        tokenURI[tokenCount] = _tokenURI;
    }

    
    /// @notice Mint Fungable GOLD
    /// @dev All Fungable gold's token ID will be 0
    /// @param amount a parameter of how many gold mint
    
    function mintGold(uint256 amount) public onlyOwner 
    {
        _mint(msg.sender, 
        GOLD, 
        amount, 
        "");
    }



    /// @notice It will return the token metadata uri by its tokenID
    /// @dev Explain to a developer any extra details
    /// @param _tokenId a parameter to get the uri
    /// @return {string} the return values of URI
    function uri(
        uint256 _tokenId
        ) override 
        public 
        view 
        returns(string memory) 
        {
        
        if(bytes(tokenURI[_tokenId]).length > 0){
            return string(
                abi.encodePacked(
                        baseUri,
                        tokenURI[_tokenId]
                    )
            );
        }else{
            return string(
                abi.encodePacked(
                        baseUri,
                        Strings.toString(_tokenId),
                        ".json"
                    )
            );
        }
        
    }

    // geters

    function getSupplyByRarity(
        Rarity _rarity
        ) private 
        pure 
        returns(uint)
        {
        if(_rarity == Rarity.COMMON){
            return 100;
        }else if(_rarity == Rarity.UNCOMMON){
            return 50;
        }else if(_rarity == Rarity.RARE){
            return 25;
        }else if(_rarity == Rarity.UNIQUE){
            return 1;
        }else{
            return 0;
        }
    }

}