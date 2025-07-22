#[test_only]
module marketplace::marketplace_tests;

use bridge::bridge_env::scenario;
use marketplace::accepted_type::{Self, AcceptedTypeRegistry};
use marketplace::listing::{Self, ListingRegistry};
use marketplace::marketplace;
use std::string::{String, utf8};
use sui::clock::{Self, Clock};
use sui::coin::{Self, Coin};
use sui::object::{Self, UID, ID};
use sui::sui::SUI;
use sui::test_scenario::{Self, Scenario};

// 테스트용 NFT 구조체
public struct TestNFT has key, store {
    id: UID,
    name: String,
}

#[test]
fun test_init_registry() {
    let mut scenario = test_scenario::begin(@0x1);
    let ctx = test_scenario::ctx(&mut scenario);

    accepted_type::init_registry(ctx);
    listing::init_registry<TestNFT>(ctx);

    test_scenario::end(scenario);
}

// #[test]
// fun test_list_item() {
//     let mut scenario = test_scenario::begin(@0x1);
//     let ctx = test_scenario::ctx(&mut scenario);

//     accepted_type::init_registry(ctx);
//     listing::init_registry<TestNFT>(ctx);

//     // Clock 생성
//     let clock = clock::create_for_testing(ctx);

//     let nft = TestNFT {
//         id: object::new(ctx),
//         name: utf8(b"Test"),
//     };

//     let type_name = utf8(b"Test");

//     marketplace::list_item(
//         type_name,
//         nft,
//         1000,
//         &mut listing::get_registry<TestNFT>(),
//         &accepted_type::get_registry(),
//         &clock,
//         ctx,
//     );

//     test_scenario::next_tx(&mut scenario, @0x1);
//     test_scenario::end(scenario);
// }
