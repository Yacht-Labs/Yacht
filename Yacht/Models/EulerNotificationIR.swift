//
//  EulerNotificationIR.swift
//  Yacht
//
//  Created by Henry Minden on 8/26/22.
//

import Foundation

struct EulerNotificationIR {
    let id: String
    let accountId: String
    let deviceId: String
    let tokenAddress: String
    let borrowAPY: String?
    let supplyAPY: String?
    let borrowThreshold: String?
    let supplyThreshold: String?
}

extension EulerNotificationIR: Decodable {
    
    enum EulerNotificationIRCodingKeys: String, CodingKey {
        case id
        case accountId
        case deviceId
        case tokenAddress
        case borrowAPY
        case supplyAPY
        case borrowThreshold
        case supplyThreshold
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: EulerNotificationIRCodingKeys.self)
        
        id = try values.decode(String.self, forKey: .id)
        accountId = try values.decode(String.self, forKey: .accountId)
        deviceId = try values.decode(String.self, forKey: .deviceId)
        tokenAddress = try values.decode(String.self, forKey: .tokenAddress)
        borrowAPY = try values.decodeIfPresent(String.self, forKey: .borrowAPY)
        supplyAPY = try values.decodeIfPresent(String.self, forKey: .supplyAPY)
        borrowThreshold = try values.decodeIfPresent(String.self, forKey: .borrowThreshold)
        supplyThreshold = try values.decodeIfPresent(String.self, forKey: .supplyThreshold)
    }
    
}
