# FAQ of Primary PFP
See FAQ [here](https://github.com/ForeverPFP/primary-pfp-contract/blob/main/faq.md)

# How to run the project
Install [foundry](https://book.getfoundry.sh/)

- build
```
forge build
```

- test
```
forge test 
```

- gas-report
```
forge test --gas-report
```

- deploy and verify in etherscan
```
forge create --rpc-url {rpc_url} \
    --private-key {private_key} \
    --etherscan-api-key {ethercan_api_key} \
    --verify \
    src/PrimaryPFP.sol:PrimaryPFP --constructor-args 0x00000000000076A84feF008CDAbe6409d2FE638B $warm_xyz_contract_address
```

## Goerli Testnet Contract Address

| Name | address |
| --- | --- |
| PrimaryPFP | [0xaaED5FB3a68F3EFC9f4312e83327981436519012](https://goerli.etherscan.io/address/0xaaED5FB3a68F3EFC9f4312e83327981436519012) |
| delegate.cash | [0x00000000000076A84feF008CDAbe6409d2FE638B](https://goerli.etherscan.io/address/0x00000000000076A84feF008CDAbe6409d2FE638B) |
| warm.xyz | [0x8E1520599567DF281dB37b9adE4C77D5a561eFD4](https://goerli.etherscan.io/address/0x8E1520599567DF281dB37b9adE4C77D5a561eFD4) |

## Mainnet Contract Address
| Name | address |
| --- | --- |
| delegate.cash | [0x00000000000076A84feF008CDAbe6409d2FE638B](https://goerli.etherscan.io/address/0x00000000000076A84feF008CDAbe6409d2FE638B) |
| warm.xyz | [0xC3AA9bc72Bd623168860a1e5c6a4530d3D80456c](https://goerli.etherscan.io/address/0xC3AA9bc72Bd623168860a1e5c6a4530d3D80456c) |

# Thanks for the innovators
This project is inspired by [Primary ENS Name](https://app.ens.domains/faq#what-is-a-primary-ens-name-record), [ForeverPunk](https://twitter.com/ForeverpunksCom) and [delegate.cash](https://delegate.cash).
