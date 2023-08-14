// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.18;

import "forge-std/Test.sol";
import "../src/AirDropToken.sol";

contract AirDropTokenTest is Test {
    AirDropToken public airdropToken;
    address public alice = address(0x1);

    mapping(address => bool) public bitmap;

    function setUp() public {
        bytes32 merkleRoot = 0xa363ce445148603408e6b99e5f58271a80b194bfce04d7270672f0ac98e086f5;
        vm.prank(address(0x99));
        airdropToken = new AirDropToken(merkleRoot);
    }

    function testClaimAirDrop() public {
        bytes32[] memory proof = new bytes32[](3);
        proof[0] = 0xbfdc70f4af1219d21cbf011973621eb006c2e83a711a0688f4521b49931a8b56;
        proof[1] = 0x7ca6faf4b88bcbb77fcba940a8967af35fe4d4d316b8bd35dd233fc12bdb8a7a;
        proof[2] = 0x06847bad5c5113e6739462332ba8640c2d04952cb924c71146eff9b955dbf46a;

        uint256 index = 0;
        uint256 amount = 10000000000000000000;

        assertEq(airdropToken.balanceOf(alice), 0);

        vm.prank(alice);
        airdropToken.claimAirDrop(proof, index, amount);

        assertEq(airdropToken.balanceOf(alice), 10000000000000000000);
    }
}
