module marketplace::accepted_type;

use std::string::{Self, String};
use sui::object::UID;

public struct AcceptedType has key {
    id: UID,
    type_name: String, // ex) GameX::Sword
    module_address: address,
    metadata_url: String,
    active: bool,
}

public fun register_type() {}

public fun is_registered() {}
