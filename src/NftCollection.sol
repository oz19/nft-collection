// SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.34;

import "../lib/openzeppelin-contracts/contracts/token/ERC721/ERC721.sol";
import {Strings} from "../lib/openzeppelin-contracts/contracts/utils/Strings.sol";

/**
 * @title NftCollection
 * @notice ERC721 collection with a fixed supply cap and sequential token IDs.
 *         Tokens are minted publicly in order starting from ID 0.
 */
contract NftCollection is ERC721 {

    using Strings for uint256;

    /// @notice The next token ID to be minted. Starts at 0.
    uint256 public currentTokenId = 0;

    /// @notice Maximum number of tokens that can ever be minted.
    uint256 public totalSupply;

    /// @notice Base URI prepended to each token's metadata path.
    string public baseUri;

    /**
     * @notice Emitted when a new token is minted.
     * @param user The address that received the token.
     * @param tokenId The ID of the minted token.
     */
    event NftMinted(address user, uint256 tokenId);

    /**
     * @notice Deploys the collection with a fixed supply and metadata base URI.
     * @param name_ The ERC721 token name.
     * @param symbol_ The ERC721 token symbol.
     * @param totalSupply_ Maximum number of tokens that can be minted.
     * @param baseUri_ Base URI for token metadata (e.g. an IPFS folder URI).
     */
    constructor(
        string memory name_,
        string memory symbol_,
        uint256 totalSupply_,
        string memory baseUri_
    ) ERC721(name_, symbol_) {
        totalSupply = totalSupply_;
        baseUri = baseUri_;
    }

    /**
     * @notice Mints the next token in sequence to the caller.
     * @dev Reverts once all tokens have been minted.
     */
    function mint() external {
        require(currentTokenId < totalSupply, "Cannot create more tokens");
        _safeMint(msg.sender, currentTokenId);
        uint256 newTokenId = currentTokenId;
        currentTokenId++;

        emit NftMinted(msg.sender, newTokenId);
    }

    /**
     * @dev Returns the base URI used to construct token URIs.
     */
    function _baseURI() internal view virtual override returns (string memory) {
        return baseUri;
    }

    /**
     * @notice Returns the metadata URI for a given token.
     * @dev Returns an empty string if no base URI is set.
     *      Reverts if the token does not exist.
     * @param tokenId The token ID to query.
     * @return The full metadata URI in the format `{baseUri}{tokenId}.json`.
     */
    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        _requireOwned(tokenId);

        string memory baseURI = _baseURI();
        return bytes(baseURI).length > 0 ? string.concat(baseURI, tokenId.toString(), ".json") : "";
    }

}
