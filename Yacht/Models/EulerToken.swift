//
//  EulerTokens.swift
//  Yacht
//
//  Created by Henry Minden on 8/26/22.
//

import Foundation

struct EulerToken {
    let address: String
    let name: String
    let symbol: String
    let price: String
    let decimals: Int
    let supplyAPY: Double
    let borrowAPY: Double
    let collateralFactor: Double
    let eulAPY: Double
}

extension EulerToken: Decodable {
    
    enum EulerTokenCodingKeys: String, CodingKey {
        case address
        case name
        case symbol
        case price
        case decimals
        case supplyAPY
        case borrowAPY
        case collateralFactor
        case eulAPY
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: EulerTokenCodingKeys.self)
        
        address = try values.decode(String.self, forKey: .address)
        name = try values.decode(String.self, forKey: .name)
        symbol = try values.decode(String.self, forKey: .symbol)
        price = try values.decode(String.self, forKey: .price)
        decimals = try values.decode(Int.self, forKey: .decimals)
        supplyAPY = try values.decode(Double.self, forKey: .supplyAPY)
        borrowAPY = try values.decode(Double.self, forKey: .borrowAPY)
        collateralFactor = try values.decode(Double.self, forKey: .collateralFactor)
        eulAPY = try values.decode(Double.self, forKey: .eulAPY)
    }
    
}