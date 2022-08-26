
//  NotificationServiceAPI.swift
//  YachtWallet
//
//  Created by Henry Minden on 8/26/22.
//

import Foundation

enum NetworkEnvironment {
    case localhost
    case staging
    case production
}

public enum NotificationServiceAPI {
    case getEulerTokens
    case postAccount(address: String, deviceId: String, name: String)
    case getAccounts(deviceId: String)
}

extension NotificationServiceAPI: EndPointType {
    
    var environmentBaseURL: String {
        switch NetworkManager.environment {
        case .localhost: return "http://192.168.1.66:3000"
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
        case .getEulerTokens:
            return "euler/tokens"
        case .postAccount:
            return "accounts"
        case .getAccounts(let deviceId):
            return "accounts/\(deviceId)"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .getEulerTokens:
            return .get
        case .postAccount:
            return .post
        case .getAccounts:
            return .get
        }
    }
    
    var task: HTTPTask {
        switch self {
        case .getEulerTokens:
            return .request
        case .postAccount(let address, let deviceId, let name):
            return .requestParameters(bodyParameters: [
                "address": address,
                "deviceId": deviceId,
                "name": name
            ], urlParameters: nil)
        case .getAccounts:
            return .request
        }
    }
    
    var headers: HTTPHeaders? {
        return nil
    }
}
