// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.18;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {BitMaps} from "@openzeppelin/contracts/utils/structs/BitMaps.sol";
import {MerkleProof} from "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";

contract AirDropToken is ERC20 {
    // bytes32 = [byte, byte, ..., byte] <- 32 bytes
    bytes32 public immutable merkleRoot;
    BitMaps.BitMap private _airdropList;

    constructor(bytes32 _merkleRoot) ERC20("AirDropToken", "ADT") {
        merkleRoot = _merkleRoot;
    }

    function claimAirDrop(bytes32[] calldata proof, uint256 index, uint256 amount) external {
        // check if already claimed
        require(!BitMaps.get(_airdropList, index), "Already claimed");

        // verify proof
        _verifyProof(proof, index, amount, msg.sender);

        // set airdrop as claimed
        BitMaps.setTo(_airdropList, index, true);

        // mint tokens
        _mint(msg.sender, amount);
    }

    function _verifyProof(bytes32[] memory proof, uint256 index, uint256 amount, address addr) private view {
        bytes32 leaf = keccak256(bytes.concat(keccak256(abi.encode(addr, index, amount))));
        require(MerkleProof.verify(proof, merkleRoot, leaf), "Invalid proof");
    }
}
