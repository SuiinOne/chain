module marketplace::accepted_type;

use marketplace::constants::get_admin_address;
use std::string::{Self, String};
use sui::object::{Self, UID};
use sui::table::{Self, Table};
use sui::tx_context::{Self, TxContext};

public struct AcceptedType has key, store {
    id: UID,
    type_name: String, // ex) GameX::Sword
    module_address: address,
    metadata_url: String,
    active: bool,
}

public struct AcceptedTypeRegistry has key {
    id: UID,
    types: Table<String, AcceptedType>,
}

// 초기화
public fun init_registry(ctx: &mut TxContext) {
    let registry = AcceptedTypeRegistry {
        id: object::new(ctx),
        types: table::new(ctx),
    };
    sui::transfer::share_object(registry);
}

// 등록
public fun register_type(
    type_name: String,
    module_address: address,
    metadata_url: String,
    registry: &mut AcceptedTypeRegistry,
    ctx: &mut TxContext,
) {
    assert!(ctx.sender()== get_admin_address(), 0); // 관리자만 실행 가능
    let accepted_type = AcceptedType {
        id: object::new(ctx),
        type_name,
        module_address,
        metadata_url,
        active: true,
    };
    table::add(&mut registry.types, type_name, accepted_type);
}

// 등록 여부 확인
public fun is_registered(type_name: String, registry: &AcceptedTypeRegistry): bool {
    table::contains(&registry.types, type_name)
}

// 등록된 타입 정보 조회
public fun get_type_info(
    type_name: String,
    registry: &AcceptedTypeRegistry,
): (address, String, bool) {
    let accepted_type = table::borrow(&registry.types, type_name);
    (accepted_type.module_address, accepted_type.metadata_url, accepted_type.active)
}

// 활성화 <-> 비활성화
public fun set_type_active(
    type_name: String,
    active: bool,
    registry: &mut AcceptedTypeRegistry,
    ctx: &TxContext,
) {
    assert!(ctx.sender() == get_admin_address(), 0);
    let accepted_type = table::borrow_mut(&mut registry.types, type_name);
    accepted_type.active = active;
}
