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

- get salt by [create2crunch](https://github.com/0age/create2crunch) and change it in [deploy script](https://github.com/ForeverPFP/primary-pfp-contract/blob/main/script/deploy.s.sol#L23)


- deploy and verify in etherscan
```
forge script --broadcast -vvvv --rpc-url {rpc_url} \
    --private-key {private_key} \
    --etherscan-api-key {ethercan_api_key} \
    --verify \
    script/deploy.s.sol:Deploy
```
- initialize with delegate cash address
```
0x00000000000076A84feF008CDAbe6409d2FE638B
```


## Finalized Deployment

|Mainnet Chain|Address|
|---|---|
|Ethereum|[0x00000000009706556bfd041ed3ea54aa406a7e60](https://etherscan.io/address/0x00000000009706556bfd041ed3ea54aa406a7e60)|

|Testnet Chain|Address|
|---|---|
|Ethereum (Goerli)|[0x00000000009706556bfd041ed3ea54aa406a7e60](https://goerli.etherscan.io/address/0x00000000009706556bfd041ed3ea54aa406a7e60)|

If you'd like to get the Primary on another EVM chain, anyone in the community can deploy to the same address and make a PR to add link here.

# Thanks for the innovators
This project is inspired by [Primary ENS Name](https://app.ens.domains/faq#what-is-a-primary-ens-name-record), [ForeverPunk](https://twitter.com/ForeverpunksCom) and [delegate.cash](https://delegate.cash).
