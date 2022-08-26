//
//  Account.swift
//  Yacht
//
//  Created by Henry Minden on 8/26/22.
//

import Foundation

struct Account {
    let id: String
    let address: String
    let name: String
    let deviceId: String
    let isActive: Bool
}

extension Account: Decodable {
    
    enum AccountCodingKeys: String, CodingKey {
        case id
        case address
        case name
        case deviceId
        case isActive
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: AccountCodingKeys.self)
        
        id = try values.decode(String.self, forKey: .id)
        address = try values.decode(String.self, forKey: .address)
        name = try values.decode(String.self, forKey: .name)
        deviceId = try values.decode(String.self, forKey: .deviceId)
        isActive = try values.decode(Bool.self, forKey: .isActive)
    }
    
}
