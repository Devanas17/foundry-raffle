// SPDX-License-Identifier: MIT

pragma solidity 0.8.19;

contract Raffle {
    // errors
    error Raffle__SendMoreToEnterRaffle();
    error Raffle__RaffleIsNotOpen();

    /***
     * @title This is a Raffle contract 
     * @author Dev Anas
     * @notice This contract is for creating a sample raffle contract
     * @dev This Raffle Contract uses Chainlink VRF for Random Number
     */

    enum RaffleState{OPEN, CALCULATING}

    // Storage Variable
    address payable[] private s_players;
    address private immutable i_owner;
    uint256 private constant MINIMUM_FEE = 0.001 ether;
    RaffleState private s_raffleState;

    // Events
    event EnterRaffle(address indexed player);


    constructor() {
        i_owner = msg.sender;
        s_raffleState = RaffleState.OPEN;
    }

    function enterRaffle() public payable{
        if(msg.value < MINIMUM_FEE) revert Raffle__SendMoreToEnterRaffle();
        if(s_raffleState != RaffleState.OPEN) revert Raffle__RaffleIsNotOpen();
        s_players.push(payable(msg.sender));
        emit EnterRaffle(msg.sender);
    }
    
}