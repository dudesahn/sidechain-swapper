// SPDX-License-Identifier: AGPL-3.0
pragma solidity ^0.8.15;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";



interface IUniV3 {
}

interface IUniV2 {
}

contract CoreLpSwapper is Ownable {
    using SafeERC20 for IERC20;
    
    address curveRouter;
    
    address balancerRouter;
    
    address v2UniRouter;
    
    address v3UniRouter;
    
    address gmxRouter;
    
    struct swapInfo {
        address startToken;
        address endToken;
        address middleToken;
        address secondMiddleToken;
        address routerOne;
        address routerTwo;
        address routerThree;
        uint24 feeOne;
        uint24 feeTwo;
        uint24 feeThree;
        uint256 depositType; // enum for curve, balancer, compound, etc
        address depositAddress;
    }
    
    mapping(vaultAddress => swapInfo) public tokenRouting;

    constructor(address _aggregator, address _executor) {
        executor = _executor;
        aggregatorV5 = IAggregatorV5(_aggregator);
    }
    
    // in this contract we should store the rewardsTokens as a mapping

    function swapForStrategy(uint256 amount, address lpToken) external onlyOwner {
        // bring in our startToken
        IERC20(startToken).transferFrom(msg.sender, address(this), amount);
        
        // TODO: everything else
    }
    
    function _v3UniSwap() internal {
    
    }
    
    function _balancerSwap() internal {
    
    }
    
    function _curveSwap() internal {
    
    }
    
    function _v2UniSwap() internal {
    
    }
    
    function _gmxSwap() internal {
    
    }
    
    function _aaveDeposit() internal {
    
    }
    
    function _compoundDeposit() internal {
    
    }
}
