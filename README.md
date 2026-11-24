# NFT Collection

An ERC721 collection with a fixed supply cap and sequential minting. Tokens are minted publicly in order, starting from ID 0. Metadata is served via a configurable base URI (e.g. an IPFS folder).

## Contract

`NftCollection.sol` extends OpenZeppelin's ERC721.

| Function | Access | Description |
|---|---|---|
| `mint()` | public | Mints the next token to the caller. Reverts when supply is exhausted. |
| `tokenURI(tokenId)` | public view | Returns `{baseUri}{tokenId}.json`. Reverts if token does not exist. |

**Constructor parameters**

| Parameter | Description |
|---|---|
| `name_` | ERC721 token name |
| `symbol_` | ERC721 token symbol |
| `totalSupply_` | Maximum number of tokens that can be minted |
| `baseUri_` | Base URI for metadata (e.g. `ipfs://<CID>/`) |

## Security notes

- `mint()` is unrestricted — any address can mint at no cost. Do not use in production without access control or a payment mechanism.
- No per-wallet mint limit is enforced.

## Usage

```shell
# Build
forge build

# Run tests
forge test

# Coverage report (src/NftCollection.sol: 100%)
forge coverage

# Deploy (set PRIVATE_KEY in your environment first)
forge script script/DeployNftCollection.s.sol --rpc-url <RPC_URL> --private-key $PRIVATE_KEY --broadcast
```
