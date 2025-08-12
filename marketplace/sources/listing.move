module marketplace::listing;

use marketplace::accepted_type::{Self, AcceptedTypeRegistry};
use std::string::{Self, String};
use sui::clock::{timestamp_ms, Clock};
use sui::coin::{Self, Coin};
use sui::event;
use sui::object::{Self, UID, ID};
use sui::sui::SUI;
use sui::table::{Self, Table};
use sui::transfer::{Self, public_transfer};
use sui::tx_context::TxContext;

// struct ----------------------------------------------------------
public struct Listing<T: key + store> has key, store {
    id: UID,
    item: T,
    owner: address,
    price: u64,
    listed_at: u64,
}

public struct ListingRegistry<T: key + store> has key {
    id: UID,
    listings: Table<ID, Listing<T>>,
}

// event ----------------------------------------------------------
public struct ListingCreated has copy, drop {
    listing_id: ID,
    owner: address,
    price: u64,
    listed_at: u64,
    type_name: String,
}

// method ----------------------------------------------------------
// 초기화
public entry fun init_registry<T: key + store>(ctx: &mut TxContext) {
    let registry = ListingRegistry<T> {
        id: object::new(ctx),
        listings: table::new(ctx),
    };
    sui::transfer::share_object(registry);
}

public fun list<T: key + store>(
    type_name: String,
    item: T,
    price: u64,
    registry: &mut ListingRegistry<T>,
    accepted_types: &AcceptedTypeRegistry,
    clock: &Clock,
    ctx: &mut TxContext,
) {
    assert!(price > 0, 1);
    assert!(accepted_type::is_registered(type_name, accepted_types), 101);

    let listing = Listing {
        id: object::new(ctx),
        item,
        owner: ctx.sender(),
        price,
        listed_at: timestamp_ms(clock),
    };

    let listing_id = object::uid_to_inner(&listing.id);

    table::add(
        &mut registry.listings,
        listing_id,
        listing,
    );

    event::emit(ListingCreated {
        listing_id,
        owner: ctx.sender(),
        price,
        listed_at: timestamp_ms(clock),
        type_name,
    });
}

// 등록 취소
public fun cancel<T: key + store>(
    // listing: Listing<T>,
    listing_id: ID,
    registry: &mut ListingRegistry<T>,
    ctx: &TxContext,
): T {
    // 등록소에서 제거
    // let removed_listing = table::remove(&mut registry.listings, object::uid_to_inner(&listing.id));
    let removed_listing = table::remove(&mut registry.listings, listing_id);
    // 소유자만 취소 가능
    assert!(removed_listing.owner == ctx.sender(), 2);

    // NFT 반환
    let Listing { id, item, owner: _, price: _, listed_at: _ } = removed_listing;
    object::delete(id);
    item
}

// 구매
public fun buy<T: key + store>(
    // listing: Listing<T>,
    listing_id: ID,
    mut payment: Coin<SUI>,
    registry: &mut ListingRegistry<T>,
    ctx: &mut TxContext,
): (T, Coin<SUI>) {
    // 등록소에서 제거
    let removed_listing = table::remove(&mut registry.listings, listing_id);

    // 자신의 NFT는 구매할 수 없음
    assert!(removed_listing.owner != ctx.sender(), 3);

    // 충분한 금액인지 확인
    assert!(coin::value(&payment) >= removed_listing.price, 4);

    // 수수료 계산
    let fee_amount = (removed_listing.price * get_marketplace_fee()) / 10000;
    let seller_amount = removed_listing.price - fee_amount;

    // 판매자에게 지급
    let seller_payment = coin::split(&mut payment, seller_amount, ctx);
    transfer::public_transfer(seller_payment, removed_listing.owner);

    // NFT 와 잔액 반환
    let Listing { id, item, owner: _, price: _, listed_at: _ } = removed_listing;
    object::delete(id);
    (item, payment)
}

// 등록 정보 조회
public fun get_listing_info<T: key + store + drop>(listing: &Listing<T>): (ID, address, u64, u64) {
    (object::uid_to_inner(&listing.id), listing.owner, listing.price, listing.listed_at)
}

// 등록된 NFT 개수 조회
public fun get_listing_count<T: key + store + drop>(registry: &ListingRegistry<T>): u64 {
    table::length(&registry.listings)
}

// 수수료
public fun get_marketplace_fee(): u64 {
    30 // 0.3%
}
