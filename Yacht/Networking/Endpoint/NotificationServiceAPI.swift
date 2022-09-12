
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
    
    case postEulerNotificationHealth(accountId: String, subAccountId: String, deviceId: String, thresholdValue: Float)
    case getEulerNotificationHealth(deviceId: String)
    case putEulerNotificationHealth(id: String, thresholdValue: Float)
    case deleteEulerNotificationHealth(id: String)
    
    case postEulerNotificationIR(deviceId: String,
                                 tokenAddress: String,
                                 borrowAPY: Float?,
                                 supplyAPY: Float?,
                                 borrowLowerThreshold: Int?,
                                 borrowUpperThreshold: Int?,
                                 supplyLowerThreshold: Int?,
                                 supplyUpperThreshold: Int?)
    case getEulerNotificationIR(deviceId: String)
    case putEulerNotificationIR(id: String,
                                 borrowAPY: Float?,
                                 supplyAPY: Float?,
                                 borrowLowerThreshold: Int?,
                                 borrowUpperThreshold: Int?,
                                 supplyLowerThreshold: Int?,
                                 supplyUpperThreshold: Int?,
                                 isActive: Bool?)
    case deleteEulerNotificationIR(id: String)
    
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
            return "notifications/euler/health"
        case .getEulerNotificationHealth(let deviceId):
            return "notifications/euler/health/\(deviceId)"
        case .putEulerNotificationHealth(let id, _):
            return "notifications/euler/health/\(id)"
        case .deleteEulerNotificationHealth(let id):
            return "notifications/euler/health/\(id)"
            
        case .postEulerNotificationIR:
            return "notifications/euler/ir"
        case .getEulerNotificationIR(let deviceId):
            return "notifications/euler/ir/\(deviceId)"
        case .putEulerNotificationIR(let id, _ , _ , _ , _ , _ , _ , _):
            return "notifications/euler/ir/\(id)"
        case .deleteEulerNotificationIR(let id):
            return "notifications/euler/ir/\(id)"
            
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
        case .putEulerNotificationHealth:
            return .put
        case .deleteEulerNotificationHealth:
            return .delete
            
        case .postEulerNotificationIR:
            return .post
        case .getEulerNotificationIR:
            return .get
        case .putEulerNotificationIR:
            return .put
        case .deleteEulerNotificationIR:
            return .delete
        
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
            
        case .postEulerNotificationHealth(let accountId, let subAccountId, let deviceId, let thresholdValue):
            return .requestParameters(bodyParameters: [
                "accountId": accountId,
                "subAccountId": subAccountId,
                "deviceId": deviceId,
                "thresholdValue": thresholdValue
            ], urlParameters: nil)
        case .getEulerNotificationHealth:
            return .request
        case .putEulerNotificationHealth(_, let thresholdValue):
            return .requestParameters(bodyParameters: [
                "thresholdValue": thresholdValue
            ], urlParameters: nil)
        case .deleteEulerNotificationHealth:
            return .request
            
        case .postEulerNotificationIR(
            let deviceId,
            let tokenAddress,
            let borrowAPY,
            let supplyAPY,
            let borrowLowerThreshold,
            let borrowUpperThreshold,
            let supplyLowerThreshold,
            let supplyUpperThreshold):
            return .requestParameters(bodyParameters: [
                "deviceId": deviceId,
                "tokenAddress": tokenAddress,
                "borrowAPY": borrowAPY as Any,
                "supplyAPY": supplyAPY as Any,
                "borrowLowerThreshold": borrowLowerThreshold as Any,
                "borrowUpperThreshold": borrowUpperThreshold as Any,
                "supplyLowerThreshold": supplyLowerThreshold as Any,
                "supplyUpperThreshold": supplyUpperThreshold as Any
            ], urlParameters: nil)
        case .getEulerNotificationIR:
            return .request
        case .putEulerNotificationIR(let id,
            let borrowAPY,
            let supplyAPY,
            let borrowLowerThreshold,
            let borrowUpperThreshold,
            let supplyLowerThreshold,
            let supplyUpperThreshold,
            let isActive):
            return .requestParameters(bodyParameters: [
                "id": id,
                "borrowAPY": borrowAPY as Any,
                "supplyAPY": supplyAPY as Any,
                "borrowLowerThreshold": borrowLowerThreshold as Any,
                "borrowUpperThreshold": borrowUpperThreshold as Any,
                "supplyLowerThreshold": supplyLowerThreshold as Any,
                "supplyUpperThreshold": supplyUpperThreshold as Any,
                "isActive": isActive as Any
            ], urlParameters: nil)
        case .deleteEulerNotificationIR:
            return .request
            
        case .getEulerAccount:
            return .request
        }
    }
    
    var headers: HTTPHeaders? {
        return nil
    }
}
