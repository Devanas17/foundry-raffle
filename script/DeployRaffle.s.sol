// SPDX-License-Identifier: MIT

pragma solidity 0.8.19;

import {Script} from "forge-std/Script.sol";
import {Raffle} from "../src/Raffle.sol";
import {HelperConfig} from "./HelperConfig.s.sol";
import {CreateSubscription, FundSubscription, AddConsumer} from "./Interaction.s.sol";

contract DeployRaffle is Script {
    // Raffle raffle;
    function run() external returns (Raffle, HelperConfig) {
        HelperConfig heperConfig = new HelperConfig();
        AddConsumer addConsumer = new AddConsumer();
        (
            uint256 entranceFee,
            uint256 interval,
            address vrfCoordinatorV2,
            bytes32 gasLane,
            uint64 subscriptionId,
            uint32 callBackGasLimit,
            address link,
            uint256 deployerKey
        ) = heperConfig.activeNetworkConfig();

        if (subscriptionId == 0) {
            CreateSubscription createSubscription = new CreateSubscription();
            subscriptionId = createSubscription.createSubscription(
                vrfCoordinatorV2,
                deployerKey
            );

            FundSubscription fundSubscription = new FundSubscription();
            fundSubscription.fundSubscription(
                vrfCoordinatorV2,
                subscriptionId,
                link,
                deployerKey
            );
        }

        vm.startBroadcast();
        Raffle raffle = new Raffle(
            entranceFee,
            interval,
            vrfCoordinatorV2,
            gasLane,
            subscriptionId,
            callBackGasLimit
        );
        vm.stopBroadcast();

        // We already have a broadcast in here
        addConsumer.addConsumer(
            address(raffle),
            vrfCoordinatorV2,
            subscriptionId,
            deployerKey
        );
        return (raffle, heperConfig);
    }
}
