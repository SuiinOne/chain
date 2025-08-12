module marketplace::constants;

// 최대 가격
const MAX_LISTING_PRICE: u64 = 1_000_000_000;
// 관리자 주소
const ADMIN_ADDRESS: address = @0x82d79ce231854ed188150fc041aa0384916684dee5c185de712808715eca9d54;

public fun get_admin_address(): address {
    ADMIN_ADDRESS
}
