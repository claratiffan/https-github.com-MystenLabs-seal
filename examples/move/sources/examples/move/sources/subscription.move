@@ -1,20 +1,18 @@
 // Copyright (c), Mysten Labs, Inc.
 // SPDX-License-Identifier: Apache-2.0
 
 // Based on the subscription pattern.
 // TODO: document and add tests
 
 module walrus::subscription;
 
 use sui::dynamic_field as df;
 use std::string::String;
 use sui::sui::SUI;
 use sui::clock::Clock;
 use sui::coin::Coin;
 use sui::{clock::Clock, coin::Coin, dynamic_field as df, sui::SUI};
 use walrus::utils::is_prefix;
 
 const EInvalidCap : u64 = 0;
 const EInvalidFee : u64 = 1;
 const ENoAccess : u64 = 2;
 const EInvalidCap: u64 = 0;
 const EInvalidFee: u64 = 1;
 const ENoAccess: u64 = 2;
 const MARKER: u64 = 3;
 
 public struct Service has key {
 @@ -43,7 +41,7 @@
 /// The associated key-ids are [pkg id]::[service id][nonce] for any nonce (thus
 /// many key-ids can be created for the same service).
 public fun create_service(fee: u64, ttl: u64, name: String, ctx: &mut TxContext): Cap {
    let service = Service {
     let service = Service {
         id: object::new(ctx),
         fee: fee,
         ttl: ttl,
 @@ -63,7 +61,12 @@
     transfer::transfer(create_service(fee, ttl, name, ctx), ctx.sender());
 }
 
 public fun subscribe(fee: Coin<SUI>, service: &Service, c: &Clock, ctx: &mut TxContext): Subscription {
 public fun subscribe(
     fee: Coin<SUI>,
     service: &Service,
     c: &Clock,
     ctx: &mut TxContext,
 ): Subscription {
     assert!(fee.value() == service.fee, EInvalidFee);
     transfer::public_transfer(fee, service.owner);
     Subscription {
 @@ -99,26 +102,15 @@
     };
 
     // Check if the id has the right prefix
     let namespace = service.id.to_bytes();
     let mut i = 0;
     if (namespace.length() > id.length()) {
         return false
     };
     while (i < namespace.length()) {
         if (namespace[i] != id[i]) {
             return false
         };
         i = i + 1;
     };
     true
     is_prefix(service.id.to_bytes(), id)
 }
 
 entry fun seal_approve(id: vector<u8>, sub: &Subscription, service: &Service, c: &Clock) {
     assert!(approve_internal(id, sub, service, c), ENoAccess);
 }
 
 /// Encapsulate a blob into a Sui object and attach it to the Subscription
 public fun publish(service: &mut Service, cap: &Cap, blob_id: String) {
     assert!(cap.service_id == object::id(service), EInvalidCap);
     df::add(&mut service.id, blob_id, MARKER);
 }
