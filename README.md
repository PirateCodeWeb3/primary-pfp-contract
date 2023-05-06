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
```
forge create --rpc-url {rpc_url} \
    --private-key {private_key} \
    --etherscan-api-key {ethercan_api_key} \
    --verify \
    src/PFPVerification.sol:PFPVerification
```

You can try the testnet for PrimaryPFP with Ethereum (Goerli) [here](https://goerli.etherscan.io/address/0xD2068Fea1e1123a68007b836178f03dEf5aD7717) and testnet for PFPVerification with Ethereum (Goerli) [here](https://goerli.etherscan.io/address/0x7a9c9c192c3F56F240f798c2D22D1b7cf2bc5bC1).

# Thanks for the innovators
This project is inspired by [Primary ENS Name](https://app.ens.domains/faq#what-is-a-primary-ens-name-record), [ForeverPunk](https://twitter.com/foreverpunksnft) and [delegate.cash](https://delegate.cash).
