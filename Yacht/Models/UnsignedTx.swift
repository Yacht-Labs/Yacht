//
//  UnsignedTx.swift
//  Yacht
//
//  Created by Henry Minden on 8/26/22.
//

import Foundation

struct UnsignedTx {
    let from: String
    let to: String
    let nonce: Int
    let value: String?
    let chainId: Int?
    let data: String?
    let gasLimit: String?
    let maxPriorityFeePerGas: String?
    let maxFeePerGas: String?
}

extension UnsignedTx: Decodable {
    
    enum UnsignedTxCodingKeys: String, CodingKey {
        case from
        case to
        case nonce
        case value
        case chainId
        case data
        case gasLimit
        case maxPriorityFeePerGas
        case maxFeePerGas
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: UnsignedTxCodingKeys.self)
        
        from = try values.decode(String.self, forKey: .from)
        to = try values.decode(String.self, forKey: .to)
        nonce = try values.decode(Int.self, forKey: .nonce)
        value = try values.decodeIfPresent(String.self, forKey: .value)
        chainId = try values.decodeIfPresent(Int.self, forKey: .chainId)
        data = try values.decodeIfPresent(String.self, forKey: .data)
        gasLimit = try values.decodeIfPresent(String.self, forKey: .gasLimit)
        maxPriorityFeePerGas = try values.decodeIfPresent(String.self, forKey: .maxPriorityFeePerGas)
        maxFeePerGas = try values.decodeIfPresent(String.self, forKey: .maxFeePerGas)
    }
    
}
