module marketplace::test_nft;

use std::string::{Self, String};
use sui::object::{Self, UID};
use sui::transfer;
use sui::tx_context::{Self, TxContext};

public struct TestNFT has key, store {
    id: UID,
    name: String,
    description: String,
    image_url: String,
}

public entry fun mint(name: String, description: String, image_url: String, ctx: &mut TxContext) {
    let nft = TestNFT {
        id: object::new(ctx),
        name,
        description,
        image_url,
    };
    // nft

    transfer::transfer(nft, ctx.sender())
}

public fun get_name(nft: &TestNFT): String {
    nft.name
}

public fun get_description(nft: &TestNFT): String {
    nft.description
}

public fun get_image_url(nft: &TestNFT): String {
    nft.image_url
}
