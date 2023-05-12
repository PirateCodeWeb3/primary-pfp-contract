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

## Goerli Testnet Contract Address

| Name | address |
| --- | --- |
| PrimaryPFP | [0xD2068Fea1e1123a68007b836178f03dEf5aD7717](https://goerli.etherscan.io/address/0xD2068Fea1e1123a68007b836178f03dEf5aD7717) |
| PFPVerification | [0x7a9c9c192c3F56F240f798c2D22D1b7cf2bc5bC1](https://goerli.etherscan.io/address/0x7a9c9c192c3F56F240f798c2D22D1b7cf2bc5bC1) |

## Goerli Testnet PFP Collection Address

| Name | address |
| --- | --- |
| wrapped punks   | [0x29674De3A40432f1d709C40f93d4d707063e73CE](https://goerli.etherscan.io/address/0x29674De3A40432f1d709C40f93d4d707063e73CE) |
| V1 CryptoPunks |[0x7053c224bF94cdbad53F80bF9029c1ba7334D774](https://goerli.etherscan.io/address/0x7053c224bF94cdbad53F80bF9029c1ba7334D774)     |
| BAYC      | [0x5f1b78a908a05835b53bbc6cdffc2dfaea10d42d](https://goerli.etherscan.io/address/0x5f1b78a908a05835b53bbc6cdffc2dfaea10d42d)      |
| MAYC      | [0xeb4be195893969a2ac2eb9650b328a19452e2156](https://goerli.etherscan.io/address/0xeb4be195893969a2ac2eb9650b328a19452e2156)         |
| Azuki      | [0xdbf46ea49b37085ad9dcd5d15e3081391ca10c6b](https://goerli.etherscan.io/address/0xdbf46ea49b37085ad9dcd5d15e3081391ca10c6b)      |
| DeGods      | [0x4F0AFBbaC4d1E738d2a3E35b9083c3E859eaa569](https://goerli.etherscan.io/address/0x4F0AFBbaC4d1E738d2a3E35b9083c3E859eaa569)         |
| Pudgy Penguins  | [0xd145e957a975ae7fcccdaaf57f59a905ab10c47f](https://goerli.etherscan.io/address/0xd145e957a975ae7fcccdaaf57f59a905ab10c47f)     |
| Milady      | [0x987830Be8D7869485C7C06a3A66e1c00F342B367](https://goerli.etherscan.io/address/0x987830Be8D7869485C7C06a3A66e1c00F342B367)      |
| Meebits      | [0x0c07c88d84337a7b32b0a41e6031ca4ac223c48c](https://goerli.etherscan.io/address/0x0c07c88d84337a7b32b0a41e6031ca4ac223c48c)        |
| Beanz      | [0x8c98a5a89Df5BCD68fc6536F4947a2E0845c0034](https://goerli.etherscan.io/address/0x8c98a5a89Df5BCD68fc6536F4947a2E0845c0034)        |
| Moonbrids      | [0x1f31e37dbefa00d76f292c0d89d8b16f54f602fb](https://goerli.etherscan.io/address/0x1f31e37dbefa00d76f292c0d89d8b16f54f602fb)      |
| Clonex      | [0x99F66c5aeaB492C6d8C9c3498570366269ff56C1](https://goerli.etherscan.io/address/0x99F66c5aeaB492C6d8C9c3498570366269ff56C1)     |
| Doodles      | [0x644cd7ab005815Fe27182a4b281993e611fe1B12](https://goerli.etherscan.io/address/0x644cd7ab005815Fe27182a4b281993e611fe1B12)        |
| Mfer      | [0x9AB055D61C8e9b36BD2518e43f3Ac531b2849FAD](https://goerli.etherscan.io/address/0x9AB055D61C8e9b36BD2518e43f3Ac531b2849FAD)           |
| Sappy Seals |[0xeB8FEB3C171f224c5B1855D452Cb080Dcf241413](https://goerli.etherscan.io/address/0xeB8FEB3C171f224c5B1855D452Cb080Dcf241413)     | 
| World Of Women | [0x1E86DC7DE5Df66c15b649c415564B53f3f3f1a7D](https://goerli.etherscan.io/address/0x1E86DC7DE5Df66c15b649c415564B53f3f3f1a7D)      |
| Cool Cats      | [0x7223dfdeCe805acA91E619E9EEDDd266062F9eB3](https://goerli.etherscan.io/address/0x7223dfdeCe805acA91E619E9EEDDd266062F9eB3)       |
| Valhalla      | [0xAd56867DBE6b01ff6480e5357601500fea66A62B](https://goerli.etherscan.io/address/0xAd56867DBE6b01ff6480e5357601500fea66A62B)          |

# Thanks for the innovators
This project is inspired by [Primary ENS Name](https://app.ens.domains/faq#what-is-a-primary-ens-name-record), [ForeverPunk](https://twitter.com/foreverpunksnft) and [delegate.cash](https://delegate.cash).
