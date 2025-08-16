// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/**
 * @title NFTMarketplace
 * @dev A comprehensive NFT marketplace for the Base ecosystem
 */
contract NFTMarketplace {
    uint256 public marketplaceFee = 250; // 2.5%
    
    struct Listing {
        uint256 listingId;
        address nftContract;
        uint256 tokenId;
        address seller;
        uint256 price;
        bool active;
    }
    
    mapping(uint256 => Listing) public listings;
    uint256 private _listingIds;
    
    event ListingCreated(uint256 indexed listingId, address indexed nftContract, uint256 indexed tokenId);
    event NFTSold(uint256 indexed listingId, address indexed buyer, uint256 price);
    
    function createListing(address nftContract, uint256 tokenId, uint256 price) external {
        require(price > 0, "Price must be greater than 0");
        
        _listingIds++;
        listings[_listingIds] = Listing({
            listingId: _listingIds,
            nftContract: nftContract,
            tokenId: tokenId,
            seller: msg.sender,
            price: price,
            active: true
        });
        
        emit ListingCreated(_listingIds, nftContract, tokenId);
    }
    
    function buyNFT(uint256 listingId) external payable {
        Listing storage listing = listings[listingId];
        require(listing.active, "Listing not active");
        require(msg.value >= listing.price, "Insufficient payment");
        
        listing.active = false;
        
        // Transfer payment to seller (simplified)
        payable(listing.seller).transfer(listing.price);
        
        emit NFTSold(listingId, msg.sender, listing.price);
    }
}
