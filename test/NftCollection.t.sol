// SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.34;

import "forge-std/Test.sol";
import "../src/NftCollection.sol";

contract TestNftCollection is Test {

    NftCollection collection;

    string name = "My NFT";
    string symbol = "MYNFT";
    uint256 totalSupply = 3;
    string baseUri = "ipfs://bafybeihve54x5uzt3jhmyc2nzhxhcic5p5d7pgy374kvofbb2ikecwthfu/";

    address user = vm.addr(1);
    address user2 = vm.addr(2);

    function setUp() public {
        collection = new NftCollection(name, symbol, totalSupply, baseUri);
    }

    function testDeployedCorrectly() public view {
        assertEq(collection.name(), name);
        assertEq(collection.symbol(), symbol);
        assertEq(collection.totalSupply(), totalSupply);
        assertEq(collection.baseUri(), baseUri);
        assertEq(collection.currentTokenId(), 0);
    }

    function testMintAssignsTokenToSender() public {
        vm.startPrank(user);

        collection.mint();

        assertEq(collection.ownerOf(0), user);
        assertEq(collection.balanceOf(user), 1);

        vm.stopPrank();
    }

    function testMintIncrementsCurrentTokenId() public {
        vm.startPrank(user);

        assertEq(collection.currentTokenId(), 0);
        collection.mint();
        assertEq(collection.currentTokenId(), 1);
        collection.mint();
        assertEq(collection.currentTokenId(), 2);

        vm.stopPrank();
    }

    function testMintEmitsNftMintedEvent() public {
        vm.startPrank(user);

        vm.expectEmit(true, true, false, false);
        emit NftCollection.NftMinted(user, 0);
        collection.mint();

        vm.stopPrank();
    }

    function testMintRevertsWhenSupplyExhausted() public {
        vm.startPrank(user);

        for (uint256 i = 0; i < totalSupply; i++) {
            collection.mint();
        }

        vm.expectRevert("Cannot create more tokens");
        collection.mint();

        vm.stopPrank();
    }

    function testTokenURIReturnsCorrectUri() public {
        vm.startPrank(user);
        collection.mint();
        vm.stopPrank();

        string memory expected = string.concat(baseUri, "0.json");
        assertEq(collection.tokenURI(0), expected);
    }

    function testTokenURIRevertsForNonExistentToken() public {
        vm.expectRevert();
        collection.tokenURI(99);
    }

    function testTokenURIReturnsEmptyStringWhenNoBaseUri() public {
        NftCollection noUriCollection = new NftCollection(name, symbol, totalSupply, "");

        vm.prank(user);
        noUriCollection.mint();

        assertEq(noUriCollection.tokenURI(0), "");
    }

    function testMultipleUsersMint() public {
        vm.prank(user);
        collection.mint();

        vm.prank(user2);
        collection.mint();

        assertEq(collection.ownerOf(0), user);
        assertEq(collection.ownerOf(1), user2);
        assertEq(collection.currentTokenId(), 2);
    }

}
