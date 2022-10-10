//
//  NetworkManager.swift
//  YachtWallet
//
//  Created by Henry Minden on 5/4/22.
//

import Foundation
import UIKit

enum NetworkResponse: String {
    case success
    case badRequest = "Bad Request"
    case authenticationError = "Auth error"
    case outdated = "The url you requested is outdated"
    case failed = "Network request failed"
    case noData = "Response returned with no data to decode"
    case unableToDecode = "Response could not be decoded"
}

enum Result<String> {
    case success
    case failure(String)
}

class NetworkManager {
    static let environment: NetworkEnvironment = BuildConfiguration.shared.network
    private let router = Router<NotificationServiceAPI>()
    private var throbberImage: UIImageView?
 
    func getEulerTokens(completion: @escaping (_ tokens: [EulerToken]?, _ error: String?) -> Void) {
        router.request(.getEulerTokens) { [self] data, response, error in
            let result = handleNetworkResponse(data: data, response: response, error: error, responseModelType: [EulerToken].self)
            completion(result.0, result.1)
        }
    }
    
    // *********************************
    // Account Methods
    // *********************************
    
    func postAccount(address: String, deviceId: String, name: String, completion: @escaping (_ account: Account?, _ error: String?) -> Void) {
        router.request(.postAccount(address: address, deviceId: deviceId, name: name)) { [self] data, response, error in
            let result = handleNetworkResponse(data: data, response: response, error: error, responseModelType: Account.self)
            completion(result.0, result.1)
        }
    }
    
    func getAccounts(deviceId: String, completion: @escaping (_ accounts: [Account]?, _ error: String?) -> Void) {
        router.request(.getAccounts(deviceId: deviceId)) { [self] data, response, error in
            let result = handleNetworkResponse(data: data, response: response, error: error, responseModelType: [Account].self)
            completion(result.0, result.1)
        }
    }
    
    func deleteAccount(id: String, completion: @escaping (_ account: Account?, _ error: String?) -> Void) {
        router.request(.deleteAccount(id: id)) { [self] data, response, error in
            let result = handleNetworkResponse(data: data, response: response, error: error, responseModelType: Account.self)
            completion(result.0, result.1)
        }
    }
    
    // *********************************
    // Euler Health Notification Methods
    // *********************************
    
    func postEulerNotificationHealth(accountId: String,
                                     subAccountId: String,
                                     deviceId: String,
                                     thresholdValue: Float,
                                     completion: @escaping (_ notification: EulerNotificationHealth?, _ error: String?) -> Void) {
        router.request(.postEulerNotificationHealth(accountId: accountId,
                                                    subAccountId: subAccountId,
                                                    deviceId: deviceId,
                                                    thresholdValue: thresholdValue)) { [self] data, response, error in
            let result = handleNetworkResponse(data: data, response: response, error: error, responseModelType: EulerNotificationHealth.self)
            completion(result.0, result.1)
        }
    }
    
    func getEulerNotificationHealth(deviceId: String, completion: @escaping (_ notifications: [EulerNotificationHealth]?, _ error: String?) -> Void) {
        router.request(.getEulerNotificationHealth(deviceId: deviceId)) { [self] data, response, error in
            let result = handleNetworkResponse(data: data, response: response, error: error, responseModelType: [EulerNotificationHealth].self)
            completion(result.0, result.1)
        }
    }
    
    func putEulerNotificationHealth(id: String, thresholdValue: Float, completion: @escaping (_ notification: EulerNotificationHealth?, _ error: String?) -> Void) {
        router.request(.putEulerNotificationHealth(id: id, thresholdValue: thresholdValue)) { [self] data, response, error in
            let result = handleNetworkResponse(data: data, response: response, error: error, responseModelType: EulerNotificationHealth.self)
            completion(result.0, result.1)
        }
    }
    
    func deleteEulerNotificationHealth(id: String, completion: @escaping (_ notification: EulerNotificationHealth?, _ error: String?) -> Void) {
        router.request(.deleteEulerNotificationHealth(id: id)) { [self] data, response, error in
            let result = handleNetworkResponse(data: data, response: response, error: error, responseModelType: EulerNotificationHealth.self)
            completion(result.0, result.1)
        }
    }
    
    //*********************************
    // Euler IR Notification Methods
    //*********************************
    
    func postEulerNotificationIR(
                                    deviceId: String,
                                    tokenAddress: String,
                                    borrowAPY: Float?,
                                    supplyAPY: Float?,
                                    borrowLowerThreshold: Int?,
                                    borrowUpperThreshold: Int?,
                                    supplyLowerThreshold: Int?,
                                    supplyUpperThreshold: Int?,
                                    completion: @escaping (_ notification: EulerNotificationIR?, _ error: String?) -> Void) {
        router.request(.postEulerNotificationIR(
                                                deviceId: deviceId,
                                                tokenAddress: tokenAddress,
                                                borrowAPY: borrowAPY,
                                                supplyAPY: supplyAPY,
                                                borrowLowerThreshold: borrowLowerThreshold,
                                                borrowUpperThreshold: borrowUpperThreshold,
                                                supplyLowerThreshold: supplyLowerThreshold,
                                                supplyUpperThreshold: supplyUpperThreshold)) { [self] data, response, error in
            let result = handleNetworkResponse(data: data, response: response, error: error, responseModelType: EulerNotificationIR.self)
            completion(result.0, result.1)
        }
    }
    
    func getEulerNotificationIR(deviceId: String, completion: @escaping (_ notifications: [EulerNotificationIR]?, _ error: String?) -> Void) {
        router.request(.getEulerNotificationIR(deviceId: deviceId)) { [self] data, response, error in
            let result = handleNetworkResponse(data: data, response: response, error: error, responseModelType: [EulerNotificationIR].self)
            completion(result.0, result.1)
        }
    }
    
    func putEulerNotificationIR(id: String,
                                    borrowAPY: Float?,
                                    supplyAPY: Float?,
                                    borrowLowerThreshold: Int?,
                                    borrowUpperThreshold: Int?,
                                    supplyLowerThreshold: Int?,
                                    supplyUpperThreshold: Int?,
                                    isActive: Bool?,
                                    completion: @escaping (_ notification: EulerNotificationIR?, _ error: String?) -> Void) {
        router.request(.putEulerNotificationIR(id: id,
                                                borrowAPY: borrowAPY,
                                                supplyAPY: supplyAPY,
                                                borrowLowerThreshold: borrowLowerThreshold,
                                                borrowUpperThreshold: borrowUpperThreshold,
                                                supplyLowerThreshold: supplyLowerThreshold,
                                                supplyUpperThreshold: supplyUpperThreshold,
                                                isActive: isActive)) { [self] data, response, error in
            let result = handleNetworkResponse(data: data, response: response, error: error, responseModelType: EulerNotificationIR.self)
            completion(result.0, result.1)
        }
    }
    
    func deleteEulerNotificationIR(id: String, completion: @escaping (_ notification: EulerNotificationIR?, _ error: String?) -> Void) {
        router.request(.deleteEulerNotificationIR(id: id)) { [self] data, response, error in
            let result = handleNetworkResponse(data: data, response: response, error: error, responseModelType: EulerNotificationIR.self)
            completion(result.0, result.1)
        }
    }
    
    //*********************************
    // Euler Account Method
    //*********************************
    
    func getEulerAccounts(address: String, completion: @escaping (_ accounts: [EulerAccount]?, _ error: String?) -> Void) {
        router.request(.getEulerAccount(address: address)) { [self] data, response, error in
            let result = handleNetworkResponse(data: data, response: response, error: error, responseModelType: [EulerAccount].self)
            completion(result.0, result.1)
        }
    }
    
    fileprivate func handleNetworkResponse<ResponseModel: Decodable>(data: Data?, response: URLResponse?, error: Error?, responseModelType: ResponseModel.Type) -> (ResponseModel?, String?) {
        if error != nil {
            return (nil, "Please check your network connection")
        }
        
        if let response = response as? HTTPURLResponse {
            let result = self.getResult(response)
            switch result {
            case .success:
                guard let responseData = data else {
                    return (nil, NetworkResponse.noData.rawValue)
                }
                do {
                    let apiResponse = try JSONDecoder().decode(responseModelType.self, from: responseData)
                    return (apiResponse, nil)
                } catch {
                    print(error)
                    return (nil, NetworkResponse.unableToDecode.rawValue)
                }
            case .failure(let networkFailureError):
                return (nil, networkFailureError)
            }
        }
        return (nil, nil)
    }
 
    fileprivate func getResult(_ response: HTTPURLResponse) -> Result<String> {
        switch response.statusCode {
        case 200...299: return .success
        case 401...499: return .failure(NetworkResponse.authenticationError.rawValue)
        case 500...599: return .failure(NetworkResponse.badRequest.rawValue)
        case 600: return .failure(NetworkResponse.outdated.rawValue)
        default: return .failure(NetworkResponse.failed.rawValue)
        }
    }
    
    private func swingSail() {
        guard let throbberImage = throbberImage else {
            return
        }
        
        UIView.animate(withDuration: 0.8, delay: 0, options: .curveEaseInOut) {
            throbberImage.transform3D = CATransform3DMakeRotation(0.8, 0, 1, 0)
        } completion: { _ in
            UIView.animate(withDuration: 0.8, delay: 0, options: .curveEaseInOut) {
                throbberImage.transform3D = CATransform3DMakeRotation(-0.8, 0, 1, 0)
            } completion: { _ in
                self.swingSail()
            }
        }
    }
    
    func throbImageview(parentView: UIView) {

        throbberImage = UIImageView(frame: CGRect(x: -100, y: -100, width: 200, height: 200))
        
        guard let throbberImage = throbberImage else {
            return
        }

        throbberImage.alpha = 0
        throbberImage.image = UIImage(named: "YachtLogo")
        throbberImage.contentMode = .scaleAspectFit
        let transformLayer = CATransformLayer()
        var perspective = CATransform3DIdentity
        perspective.m34 = -1 / 500
        transformLayer.transform = perspective
        transformLayer.position = CGPoint(x: parentView.bounds.midX, y: parentView.bounds.midY)
        transformLayer.anchorPointZ = -100
        transformLayer.addSublayer(throbberImage.layer)
        parentView.layer.addSublayer(transformLayer)
        
        UIView.animate(withDuration: 0.2, delay: 0) {
            throbberImage.alpha = 1
        } completion: { _ in
            self.swingSail()
        }
    }
    
    func stopThrob() {
        guard let throbberImage = throbberImage else {
            return
        }
        
        UIView.animate(withDuration: 1.0, delay: 0) {
            throbberImage.alpha = 0
        } completion: { _ in
            throbberImage.layer.removeAllAnimations()
        }
    }
    
    func showErrorAlert(title: String, message: String, vc: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { _ in }))
        vc.present(alert, animated: true, completion: nil)
    }

}
