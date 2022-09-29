//
//  EulerLoan.swift
//  Yacht
//
//  Created by Henry Minden on 8/29/22.
//

import Foundation

struct EulerLoan {
    let token: EulerToken
    let amount: String
}

extension EulerLoan: Decodable {
    
    enum EulerLoanCodingKeys: String, CodingKey {
        case token
        case amount
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: EulerLoanCodingKeys.self)
        
        token = try values.decode(EulerToken.self, forKey: .token)
        amount = try values.decode(String.self, forKey: .amount)
    }
    
}

