// SPDX-License-Identifier: MIT
pragma solidity 0.8.4;

interface ERC721 {
    function balanceOf(address owner) external view returns (uint balance);
}

contract NftHelper {

    address public nftAddress;

    event NftAddressSet(address newNftAddress);

    constructor(address _nftAddress) {
        require(_nftAddress != address(0), "Invalid NFT address");
        nftAddress = _nftAddress;
    }

    function setNftAddress(address _newNftAddress) external {
        require(_newNftAddress != address(0), "Invalid address");
        nftAddress = _newNftAddress;
        emit NftAddressSet(_newNftAddress);
    }

    function userHasNft(address _user) external view returns (bool) {
        ERC721 nftContract = ERC721(nftAddress);
        return nftContract.balanceOf(_user) > 0;
    }
}
