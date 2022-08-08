// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;

import "./interfaces/IToy.sol";

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Toy is IToy, ERC20, Ownable {
    uint256 private _lowerBoundRandom;
    uint256 private _upperBoundRandom;

    constructor(string memory _name, string memory _symbol) ERC20(_name, _symbol) {
        _lowerBoundRandom = 10; // default value
        _upperBoundRandom = 100; // default value
    }

    function randomEtherToToy() external payable override {
        require(msg.value > 0, "Cannot send 0 ETH");

        uint256 tokensToMint = _getPseudoRandomNumber(msg.value);
        _mint(msg.sender, tokensToMint);
    }

    function setRandomBounds(uint256 lower, uint256 upper) external onlyOwner {
        require(lower < upper, "Invalid random bounds");

        _lowerBoundRandom = lower;
        _upperBoundRandom = upper;
    }

    function _getPseudoRandomNumber(uint256 multiplier) internal view returns (uint256) {
        // WARNING: pseudo random number, can be predicted by the miner. NOT TO BE USED IN PRODUCTION. Use Chainlink VRF.
        uint256 pseudoRandomNumber = uint256(
            keccak256(abi.encodePacked(block.number, block.timestamp, block.difficulty, msg.sender))
        );

        // apply the bounds to the random number
        uint256 maxRandomValue = multiplier * (_upperBoundRandom - _lowerBoundRandom);
        uint256 minRandomValue = multiplier * _lowerBoundRandom;
        pseudoRandomNumber = (pseudoRandomNumber % maxRandomValue) + minRandomValue;

        return pseudoRandomNumber; // _lowerBoundRandom <= pseudoRandomNumber < _upperBoundRandom
    }
}
