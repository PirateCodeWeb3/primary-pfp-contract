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

- deploy and verify in ethercan
```
forge create --rpc-url {rpc_url} \
    --private-key {private_key} \
    --etherscan-api-key {ethercan_api_key} \
    --verify \
    src/ForeverPFP.sol:ForeverPFP
```

You can try the testnet Chain with Ethereum (Goerli) [here](https://goerli.etherscan.io/address/0x03ac7dd6bf9a72d3522000b366f531652b10ad74).

# Thanks for the innovators
This project is inspired by [Primary ENS Name](https://app.ens.domains/faq#what-is-a-primary-ens-name-record), [ForeverPunk](https://twitter.com/foreverpunksnft) and [delegate.cash](https://delegate.cash).
