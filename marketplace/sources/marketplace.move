module marketplace::marketplace;

use marketplace::accepted_type::{Self, AcceptedTypeRegistry, AcceptedType};
use marketplace::constants::get_admin_address;
use marketplace::listing::{Self, ListingRegistry, Listing};
use std::string::String;
use sui::clock::Clock;
use sui::coin::{Self, Coin, destroy_zero};
use sui::object::{Self, UID, ID};
use sui::sui::SUI;
use sui::transfer::{Self, public_transfer};
use sui::tx_context::{Self, TxContext};

public entry fun list_item<T: key + store>(
    type_name: String,
    item: T,
    price: u64,
    registry: &mut ListingRegistry<T>,
    accepted_types: &AcceptedTypeRegistry,
    clock: &Clock,
    ctx: &mut TxContext,
) {
    listing::list(type_name, item, price, registry, accepted_types, clock, ctx);
}

public entry fun cancel_item<T: key + store>(
    // listing: Listing<T>,
    listing_id: ID,
    registry: &mut ListingRegistry<T>,
    ctx: &mut TxContext,
) {
    let item = listing::cancel(listing_id, registry, ctx);
    transfer::public_transfer(item, ctx.sender())
}

public entry fun buy_item<T: key + store>(
    // listing: Listing<T>,
    listing_id: ID,
    payment: Coin<SUI>,
    registry: &mut ListingRegistry<T>,
    ctx: &mut TxContext,
) {
    let (item, change) = listing::buy(listing_id, payment, registry, ctx);
    transfer::public_transfer(item, ctx.sender());
    if (coin::value(&change) > 0) {
        transfer::public_transfer(change, ctx.sender())
    } else {
        coin::destroy_zero(change)
    }
}
