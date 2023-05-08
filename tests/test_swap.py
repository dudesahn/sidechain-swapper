import pytest
from oneinch_py import OneInchSwap, TransactionHelper, OneInchOracle
from brownie import chain

# test reducing the debtRatio on a strategy and then harvesting it
def test_swap(
    management,
    swapper,
):
    # get our swap ready
    exchange = OneInchSwap(management.address, chain=chain_name)
    
    # do our approvals
    usdt = Contract("0xFd086bC7CD5C481DCC9C85ebE478A1C0b69FCbb9")
    usdt.approve(swapper.aggregatorV5(), 2 ** 256 - 1, {'from': management})
