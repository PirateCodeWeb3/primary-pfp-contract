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
get salt by [create2crunch](https://github.com/0age/create2crunch), change it
in script/deploy.s.sol

```
forge script --broadcast -vvvv --rpc-url {rpc_url} \
    --private-key {private_key} \
    --etherscan-api-key {ethercan_api_key} \
    --verify \
    script/Deploy.s.sol:Deploy
```
- initialize with delegate cash address
https://goerli.etherscan.io/tx/0xa224c8b5b41430ffd059ca0d30532960f5ead3082691b2c7eb4619b9ee53216f


## Goerli Testnet Contract Address

| Name | address |
| --- | --- |
| PrimaryPFP | [0x00000000009706556bfd041ed3ea54aa406a7e60](https://goerli.etherscan.io/address/0x00000000009706556bfd041ed3ea54aa406a7e60) |
| delegate.cash | [0x00000000000076A84feF008CDAbe6409d2FE638B](https://goerli.etherscan.io/address/0x00000000000076A84feF008CDAbe6409d2FE638B) |

## Mainnet Contract Address
| Name | address |
| --- | --- |
| PrimaryPFP | [0x00000000009706556bfd041ed3ea54aa406a7e60](https://etherscan.io/address/0x00000000009706556bfd041ed3ea54aa406a7e60) |
| delegate.cash | [0x00000000000076A84feF008CDAbe6409d2FE638B](https://etherscan.io/address/0x00000000000076A84feF008CDAbe6409d2FE638B) |


# Thanks for the innovators
This project is inspired by [Primary ENS Name](https://app.ens.domains/faq#what-is-a-primary-ens-name-record), [ForeverPunk](https://twitter.com/ForeverpunksCom) and [delegate.cash](https://delegate.cash).
