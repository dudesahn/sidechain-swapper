import pytest
from oneinch_py import OneInchSwap, TransactionHelper, OneInchOracle
from brownie import config, Contract, ZERO_ADDRESS, chain, interface, accounts

# test reducing the debtRatio on a strategy and then harvesting it
def test_swap(
    management,
    swapper,
    chain_name,
):
    # get our swap ready
    exchange = OneInchSwap(management.address, chain=chain_name)

    # do our approvals
    usdt = Contract("0xFd086bC7CD5C481DCC9C85ebE478A1C0b69FCbb9")
    weth = Contract("0x82aF49447D8a07e3bd95BD0d56f35241523fBab1")
    usdt.approve(swapper.address, 2**256 - 1, {"from": management})
    swapper.approveToken(usdt.address, True, {"from": management})

    # get our data
    to_send = usdt.address
    get_swap_info = exchange.get_swap(to_send, "WETH", 10, 0.5, decimal=6)
    amount_out = get_swap_info["toTokenAmount"]
    min_out = int(amount_out) * 0.995
    data = get_swap_info["tx"]["data"]

    # create our swap
    tx = swapper.swapForStrategy(
        management.address,
        usdt.address,
        weth.address,
        10e6,
        min_out,
        data,
        {"from": management},
    )
    print("Return values:", tx.return_value)
