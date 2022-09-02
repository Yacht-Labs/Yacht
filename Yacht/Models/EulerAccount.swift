//
//  EulerAccount.swift
//  Yacht
//
//  Created by Henry Minden on 8/29/22.
//

import Foundation

struct EulerAccount {
    let supplies: [EulerLoan]
    let borrows: [EulerLoan]
    let healthScore: Double
}

extension EulerAccount: Decodable {
    
    enum EulerAccountCodingKeys: String, CodingKey {
        case supplies
        case borrows
        case healthScore
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: EulerAccountCodingKeys.self)
        
        supplies = try values.decode([EulerLoan].self, forKey: .supplies)
        borrows = try values.decode([EulerLoan].self, forKey: .borrows)
        healthScore = try values.decode(Double.self, forKey: .healthScore)
    }
    
}