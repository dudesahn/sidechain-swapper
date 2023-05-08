// SPDX-License-Identifier: AGPL-3.0
pragma solidity ^0.8.15;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

interface IAggregatorV5 {
    struct SwapDescription {
        IERC20 srcToken;
        IERC20 dstToken;
        address srcReceiver;
        address dstReceiver;
        uint256 amount;
        uint256 minReturnAmount;
        uint256 flags;
    }

    function swap(address, SwapDescription memory, bytes32, bytes32) external;
}

contract OneInchSwapper is Ownable {
    using SafeERC20 for IERC20;

    IAggregatorV5 public aggregatorV5;
    address public executor;

    constructor(address _aggregator, address _executor) {
        executor = _executor;
        aggregatorV5 = IAggregatorV5(_aggregator);
    }

    function swapForStrategy(
        address _strategy,
        address _sourceToken,
        address _destinationToken,
        uint256 _amountIn,
        uint256 _amountOut,
        bytes32 _data
    ) external onlyOwner {
        IERC20(_sourceToken).transferFrom(_strategy, address(this), _amountIn);
        IAggregatorV5.SwapDescription memory swapInfo = IAggregatorV5.SwapDescription(
            IERC20(_sourceToken),
            IERC20(_destinationToken),
            address(this),
            _strategy,
            _amountIn,
            _amountOut,
            0
        );

        aggregatorV5.swap(executor, swapInfo, 0, _data);
    }

    function approveToken(address token, bool approve) external onlyOwner {
        if (approve) {
            IERC20(token).safeApprove(address(aggregatorV5), type(uint256).max);
        } else {
            IERC20(token).safeApprove(address(aggregatorV5), 0);
        }
    }
}
