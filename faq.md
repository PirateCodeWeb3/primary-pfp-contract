## Why primary PFP?

PFP holder can have more than one PFPs in one address, but for the social networking better knowing your "face", it would be better choose a primary PFP and set it onchain.

We have getName(address) function provided by ENS now, we will have getPFP(address) function by PrimaryPFP, with this you can easy to get your Ethereum ID(ENS name and PFP image) anywhere with ethereum address signed to login.

## Why not ENS avatar?

We can [set avatar in ENS](https://medium.com/@brantly.eth/step-by-step-guide-to-setting-an-nft-as-your-ens-profile-avatar-3562d39567fc), but without ownership verification, you can set other people's PFP image, PrimaryPFP verify the ownership to make accurate onchain data.

## Any fee set/remove primary PFP?

No.

## Can I set my primary PFP to another address?

Yes, you can set your PFP to any address anytime by your token owner address.

## I have used delegate.cash/warm.xyz to seperate my cold & hot wallet, is that primary PFP support it?

Yes, the contract support delegate.cash and warm.xyz.

## What is set primary for delegate?

It worked the same way like delegate.cash, you can set your primary PFP to an delegate address which can be a hotwallet to avoid scammed by signing.

The best practice would be set your ENS primary name to a hotwallet, and set your primary PFP delegate to the hotwallet from your PFP vault.

## How can I remove the delegate?

Remove it by owner or set the same PFP to a new address is the way to remove delegate.

## What if I sold my primary PFP?

The primary PFP data is still in the contract if the new owner don't override it.

## Any auditing on primary PFP?

The primary PFP contract neither save PFPs nor asking approvals for PFPs, so it's not audited.

User just need one transaction to register primary data onchain like delegate.cash.

You can use delegate.cash or warm.xyz wallet to set primary PFP, which risk 0 for your NFT.
