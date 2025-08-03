// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import {KRNL, KrnlPayload, KernelParameter, KernelResponse} from "./KRNL.sol";
// ===============================
// This smart contract is specifically built to be compatible with kernel 337 as an example.
// If you are using this source code as a project template, make sure you change the following lines.
// Line 35
// Line 37
// ===============================
contract Sample is KRNL {
    // Token Authority public key as a constructor
    constructor(address _tokenAuthorityPublicKey) KRNL(_tokenAuthorityPublicKey) {}

    // Enum for move and result
    enum Move { Rock, Paper, Scissors }
    enum Result { Win, Lose, Draw }


   event GameResult(address indexed player, Move playerMove, Move computerMove, Result result);
    // event BestOfThreeResult(address indexed player, uint8 wins, uint8 losses, uint8 draws, string finalResult);


    // Protected function
    function play(
        KrnlPayload memory krnlPayload,
        uint8 _playerMove
    )
        external
        onlyAuthorized(krnlPayload, abi.encode(_playerMove))
    {
        Move computerMove ;
        Result result;
        // player = msg.sender;
        // Decode response from kernel
        KernelResponse[] memory kernelResponses = abi.decode(krnlPayload.kernelResponses, (KernelResponse[]));
        uint256 rand;
        for (uint i; i < kernelResponses.length; i ++) {
            // Change the line below to match with your selected kernel(s)
            if (kernelResponses[i].kernelId == 1681) {
                // Change the code below to match with the return data type from this kernel
                rand = abi.decode(kernelResponses[i].result, (uint256));
                computerMove = Move(rand);

            if  (Move(_playerMove) == computerMove) {
                    result = Result.Draw;
            } else if ((_playerMove+ 1) % 3 == uint8(computerMove)) {
                result = Result.Lose;
            } else {
                 result = Result.Win;
            }
            }
            // ===============================
            // If you have more than 1 kernel, you can add more conditions
            // if (kernelResponses[i].kernelId == REPLACE_WITH_KERNEL_ID) {
            //     // Change the code below to match with the return data type from this kernel
            //     foo = abi.decode(kernelResponses[i].result, (bool));
            // }
            // ===============================
        }



        
        emit GameResult(msg.sender, Move(_playerMove), computerMove, result);
    }


}

// ===============================
// Simple version of smart contract example. It does not contain the decoding part.
// No response from kernel is shown.
// No event is emitted during the transaction.
// ===============================

// contract Sample is KRNL {
//     constructor(address _tokenAuthorityPublicKey) KRNL(_tokenAuthorityPublicKey) {}

//     string message = "hello";

//     function protectedFunction(
//         KrnlPayload memory krnlPayload,
//         string memory input
//     )
//         external
//         onlyAuthorized(krnlPayload, abi.encode(input))
//     {
//         message = input;
//     }

//     function readMessage() external view returns (string memory) {
//         return message;
//     }
// }

