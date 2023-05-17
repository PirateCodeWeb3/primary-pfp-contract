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
    src/PrimaryPFP.sol:PrimaryPFP
```

## Goerli Testnet Contract Address

| Name | address |
| --- | --- |
| PrimaryPFP | [0xD2068Fea1e1123a68007b836178f03dEf5aD7717](https://goerli.etherscan.io/address/0xD2068Fea1e1123a68007b836178f03dEf5aD7717) |

# Thanks for the innovators
This project is inspired by [Primary ENS Name](https://app.ens.domains/faq#what-is-a-primary-ens-name-record), [ForeverPunk](https://twitter.com/foreverpunksnft) and [delegate.cash](https://delegate.cash).
