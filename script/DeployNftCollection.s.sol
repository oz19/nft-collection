// SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.34;

import {NftCollection} from "../src/NftCollection.sol";
import {Script} from "forge-std/Script.sol";

contract DeployNftCollection is Script {

    function run() external returns(NftCollection) {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        
        vm.startBroadcast(deployerPrivateKey);

        string memory name_ = "My NFT";
        string memory symbol_ = "MYNFT";
        uint256 totalSupply_ = 2;
        string memory baseUri_ = "ipfs://bafybeihve54x5uzt3jhmyc2nzhxhcic5p5d7pgy374kvofbb2ikecwthfu/";

        NftCollection nftCollection = new NftCollection(name_, symbol_, totalSupply_, baseUri_);

        vm.stopBroadcast();

        return nftCollection;
    }
}