module marketplace::error;

// 공통 에러
const E_NOT_ADMIN: u64 = 0; // 관리자인지
const E_INVALID_PRICE: u64 = 1; // 유효한 가격인지
const E_INSUFFICIENT_BALANCE: u64 = 2; // balance
const E_ITEM_NOT_FOUND: u64 = 3; // item 존재 여부

// accepted_type 관련 에러
const E_TYPE_ALREADY_REGISTERED: u64 = 100;
const E_TYPE_NOT_REGISTERED: u64 = 101;
const E_TYPE_INACTIVE: u64 = 102;

// listing 관련 에러
const E_LISTING_NOT_FOUND: u64 = 200;
const E_LISTING_ALREADY_EXISTS: u64 = 201;
const E_LISTING_EXPIRED: u64 = 202;
