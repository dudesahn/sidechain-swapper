import pytest
from brownie import config, Contract, ZERO_ADDRESS, chain, interface, accounts
from eth_abi import encode_single
import requests


@pytest.fixture(scope="function", autouse=True)
def isolate(fn_isolation):
    pass


@pytest.fixture(scope="session")
def management(chain):
    current_chain = chain.id
    if current_chain == 42161:
        mgmt = accounts.at("0xC6387E937Bcef8De3334f80EDC623275d42457ff", force=True)
    yield mgmt


@pytest.fixture(scope="session")
def chain_name(chain):
    current_chain = chain.id
    if current_chain == 42161:
        chain_name = "arbitrum"
    yield chain_name


@pytest.fixture(scope="function")
def swapper(OneInchSwapper, management, chain):
    current_chain = chain.id
    if current_chain == 42161:
        swapper = management.deploy(
            OneInchSwapper,
            "0x1111111254eeb25477b68fb85ed929f73a960582",
            "0x64768A3a2453F1E8DE9e43e92D65Fc36E4c9872d",
        )
        print("Arbitrum")
    yield swapper
