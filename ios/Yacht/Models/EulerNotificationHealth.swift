//
//  EulerNotificationHealth.swift
//  Yacht
//
//  Created by Henry Minden on 8/26/22.
//

import Foundation

struct EulerNotificationHealth {
    let id: String
    let accountId: String
    let deviceId: String
    let thresholdValue: Float
    let isActive: Bool
    let subAccountId: String?
    let seen: Bool
}

extension EulerNotificationHealth: Decodable {
    
    enum EulerNotificationHealthCodingKeys: String, CodingKey {
        case id
        case accountId
        case deviceId
        case thresholdValue
        case isActive
        case subAccountId
        case seen
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: EulerNotificationHealthCodingKeys.self)
        
        id = try values.decode(String.self, forKey: .id)
        accountId = try values.decode(String.self, forKey: .accountId)
        deviceId = try values.decode(String.self, forKey: .deviceId)
        thresholdValue = try values.decode(Float.self, forKey: .thresholdValue)
        isActive = try values.decode(Bool.self, forKey: .isActive)
        subAccountId = try values.decode(String.self, forKey: .subAccountId)
        seen = try values.decode(Bool.self, forKey: .seen)
    }
    
}
