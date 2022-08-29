
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
    case postEulerNotificationHealth(accountId: String, deviceId: String, thresholdValue: String)
    case getEulerNotificationHealth(deviceId: String)
    case postEulerNotificationIR(accountId: String,
                                 deviceId: String,
                                 tokenAddress: String,
                                 borrowAPY: String?,
                                 supplyAPY: String?,
                                 borrowThreshold: String?,
                                 supplyThreshold:String?)
    case getEulerNotificationIR(deviceId: String)
    case getEulerAccount(address: String)
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
        case .postEulerNotificationHealth:
            return "euler/health"
        case .getEulerNotificationHealth(let deviceId):
            return "euler/health/\(deviceId)"
        case .postEulerNotificationIR:
            return "euler/ir"
        case .getEulerNotificationIR(let deviceId):
            return "euler/ir/\(deviceId)"
        case .getEulerAccount(let address):
            return "euler/account/\(address)"
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
        case .postEulerNotificationHealth:
            return .post
        case .getEulerNotificationHealth:
            return .get
        case .postEulerNotificationIR:
            return .post
        case .getEulerNotificationIR:
            return .get
        case .getEulerAccount:
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
        case .postEulerNotificationHealth(let accountId, let deviceId, let thresholdValue):
            return .requestParameters(bodyParameters: [
                "accountId": accountId,
                "deviceId": deviceId,
                "thresholdValue": thresholdValue
            ], urlParameters: nil)
        case .getEulerNotificationHealth:
            return .request
        case .postEulerNotificationIR(let accountId,
            let deviceId,
            let tokenAddress,
            let borrowAPY,
            let supplyAPY,
            let borrowThreshold,
            let supplyThreshold):
            return .requestParameters(bodyParameters: [
                "accountId": accountId,
                "deviceId": deviceId,
                "tokenAddress": tokenAddress,
                "borrowAPY": borrowAPY as Any,
                "supplyAPY": supplyAPY as Any,
                "borrowThreshold": borrowThreshold as Any,
                "supplyThreshold": supplyThreshold as Any
            ], urlParameters: nil)
        case .getEulerNotificationIR:
            return .request
        case .getEulerAccount:
            return .request
        }
    }
    
    var headers: HTTPHeaders? {
        return nil
    }
}
