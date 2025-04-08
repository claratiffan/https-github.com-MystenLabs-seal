// Copyright (c), Mysten Labs, Inc.
 // SPDX-License-Identifier: Apache-2.0
 
 // Based on the allowlist pattern
 
 module walrus::allowlist;
 
 use sui::dynamic_field as df;
 use std::string::String;
 use sui::dynamic_field as df;
 use walrus::utils::is_prefix;
 
 const EInvalidCap : u64 = 0;
 const ENoAccess : u64 = 1;
 const EDuplicate : u64 = 2;
 const EInvalidCap: u64 = 0;
 const ENoAccess: u64 = 1;
 const EDuplicate: u64 = 2;
 const MARKER: u64 = 3;
 
 public struct Allowlist has key {
 @@ -73,16 +74,9 @@
 fun approve_internal(caller: address, id: vector<u8>, allowlist: &Allowlist): bool {
     // Check if the id has the right prefix
     let namespace = namespace(allowlist);
     let mut i = 0;
     if (namespace.length() > id.length()) {
     if (!is_prefix(namespace, id)) {
         return false
     };
     while (i < namespace.length()) {
         if (namespace[i] != id[i]) {
             return false
         };
         i = i + 1;
     };
 
     // Check if user is in the allowlist
     allowlist.list.contains(&caller)
