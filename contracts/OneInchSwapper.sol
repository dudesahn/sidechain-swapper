// SPDX-License-Identifier: AGPL-3.0
pragma solidity ^0.8.15;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelinLegacy/contracts/token/ERC20/IERC20.sol";
import "@openzeppelinLegacy/contracts/token/ERC20/SafeERC20.sol";

interface IAggregatorV5 {
    struct SwapDescription {
        IERC20 srcToken;
        IERC20 dstToken;
        address payable srcReceiver;
        address payable dstReceiver;
        uint256 amount;
        uint256 minReturnAmount;
        uint256 flags;
    }

    function swap(address, SwapDescription, bytes32, bytes32) external;
}

contract OneInchSwapper is Ownable {
    using SafeERC20 for IERC20;

    IAggregatorV5 public aggregatorV5 =
        IAggregatorV5(0x1111111254eeb25477b68fb85ed929f73a960582);
    address public executor = 0x64768A3a2453F1E8DE9e43e92D65Fc36E4c9872d;

    function swapForStrategy(
        address strategy,
        address sourceToken,
        address destinationToken,
        uint256 amountIn,
        uint256 amountOut,
        bytes32 _data
    ) {
        IERC20(sourceToken).transferFrom(strategy, address(this), amount);
        aggregatorV5.swap(
            executor,
            (
                sourceToken,
                destinationToken,
                address(this),
                strategy,
                amount,
                amountOut,
                0
            ),
            0,
            _data
        );
    }

    function approveToken(address token, bool approve) external onlyOwner {
        if (approve) {
            IERC20(token).approve(address(aggregatorV5), type(uint256).max);
        } else {
            IERC20(token).approve(address(aggregatorV5), 0);
        }
    }
}
