module marketplace::listing;

use sui::coin::Coin;
use sui::object::UID;
use sui::transfer;

public struct Listing<T: key + store> has key {
    id: UID,
    item: T,
    owner: address,
    price: u64,
    listed_at: u64,
}

public fun list<T: key + store>() {}

public fun cancel() {}

public fun buy<T: key + store>() {}
