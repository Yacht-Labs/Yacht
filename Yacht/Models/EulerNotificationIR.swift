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
    let borrowAPY: Float?
    let supplyAPY: Float?
    let borrowLowerThreshold: Int?
    let borrowUpperThreshold: Int?
    let supplyLowerThreshold: Int?
    let supplyUpperThreshold: Int?
    let isActive: Bool
}

extension EulerNotificationIR: Decodable {
    
    enum EulerNotificationIRCodingKeys: String, CodingKey {
        case id
        case accountId
        case deviceId
        case tokenAddress
        case borrowAPY
        case supplyAPY
        case borrowLowerThreshold
        case borrowUpperThreshold
        case supplyLowerThreshold
        case supplyUpperThreshold
        case isActive
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: EulerNotificationIRCodingKeys.self)
        
        id = try values.decode(String.self, forKey: .id)
        accountId = try values.decode(String.self, forKey: .accountId)
        deviceId = try values.decode(String.self, forKey: .deviceId)
        tokenAddress = try values.decode(String.self, forKey: .tokenAddress)
        borrowAPY = try values.decodeIfPresent(Float.self, forKey: .borrowAPY)
        supplyAPY = try values.decodeIfPresent(Float.self, forKey: .supplyAPY)
        borrowLowerThreshold = try values.decodeIfPresent(Int.self, forKey: .borrowLowerThreshold)
        borrowUpperThreshold = try values.decodeIfPresent(Int.self, forKey: .borrowUpperThreshold)
        supplyLowerThreshold = try values.decodeIfPresent(Int.self, forKey: .supplyLowerThreshold)
        supplyUpperThreshold = try values.decodeIfPresent(Int.self, forKey: .supplyUpperThreshold)
        isActive = try values.decode(Bool.self, forKey: .isActive)
    }
    
}
