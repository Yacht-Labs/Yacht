//
//  WalletServiceAPI.swift
//  YachtWallet
//
//  Created by Henry Minden on 5/4/22.
//

import Foundation

enum NetworkEnvironment {
    case localhost
    case staging
    case production
}

public enum WalletServiceAPI {
    case buildWethDeposit(value: String, from: String, chainId: Int, contractAddress: String)
}

extension WalletServiceAPI: EndPointType {
    
    var environmentBaseURL: String {
        switch NetworkManager.environment {
        case .localhost: return "http://localhost:8080/"
        case .staging: return ""
        case .production: return ""
        }
    }
    
    var baseURL: URL {
        guard let url = URL(string: environmentBaseURL) else { fatalError("baseURL could not be configured.")}
        return url
    }
    
    var path: String {
        switch self {
        case .buildWethDeposit:
            return "buildWethDeposit"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .buildWethDeposit:
            return .post
        }
    }
    
    var task: HTTPTask {
        switch self {
        case .buildWethDeposit(let value, let from, let chainId, let contractAddress):
            return .requestParameters(bodyParameters: [
                "value": value,
                "from": from,
                "chainId": chainId,
                "contractAddress": contractAddress
            ], urlParameters: nil)
        }
    }
    
    var headers: HTTPHeaders? {
        return nil
    }
}
