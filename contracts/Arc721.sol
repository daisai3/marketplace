// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "./libraries/OperatorRole.sol";

/**
 * @title Arc721
 * Arc721 - ERC721 contract that has minting functionality.
 */
contract Arc721 is OperatorRole, ERC721, ERC721Enumerable {
    string public uri;

    /// @notice Contract constructor
    constructor(string memory uri_) ERC721("Arc721", "ARC721") {
        uri = uri_;
    }

    /// @notice Set the base URI
    function setBaseURI(string memory uri_) external onlyOperator {
        uri = uri_;
    }

    function _baseURI() internal view override returns (string memory) {
        return uri;
    }

    /**
     * @dev transfer the token if the tokenId exists, otherwise mint the token
     *
     * Add the TransferManagerERC721 address as an operator to allow the lazymint
     *
     * @param from address that is sending a token
     * @param to address that is receiving a token
     * @param tokenId token id that is being sent or minted
     */
    function transferFromOrMint(
        address from,
        address to,
        uint256 tokenId
    ) external onlyOperator {
        if (_exists(tokenId)) {
            safeTransferFrom(from, to, tokenId, "");
        } else {
            _mint(to, tokenId);
        }
    }

    /**
     * @dev Hook that is called before any token transfer. This includes minting
     * and burning.
     *
     * Calling conditions:
     *
     * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
     * transferred to `to`.
     * - When `from` is zero, `tokenId` will be minted for `to`.
     * - When `to` is zero, ``from``'s `tokenId` will be burned.
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     *
     * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
     */
    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal virtual override(ERC721, ERC721Enumerable) {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    /**
     * @dev See {IERC165-supportsInterface}.
     */
    function supportsInterface(bytes4 interfaceId)
        public
        view
        virtual
        override(ERC721, ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}
