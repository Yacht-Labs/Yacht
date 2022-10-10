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

struct NetworkManager {
    static let environment: NetworkEnvironment = BuildConfiguration.shared.network
    private let router = Router<NotificationServiceAPI>()
    private var throbberImage: UIImageView?
 
    func getEulerTokens(completion: @escaping (_ tokens: [EulerToken]?, _ error: String?) -> Void) {
        router.request(.getEulerTokens) { data, response, error in
            let result = handleNetworkResponse(data: data, response: response, error: error, responseModelType: [EulerToken].self)
            completion(result.0, result.1)
        }
    }
    
    // *********************************
    // Account Methods
    // *********************************
    
    func postAccount(address: String, deviceId: String, name: String, completion: @escaping (_ account: Account?, _ error: String?) -> Void) {
        router.request(.postAccount(address: address, deviceId: deviceId, name: name)) { data, response, error in
            let result = handleNetworkResponse(data: data, response: response, error: error, responseModelType: Account.self)
            completion(result.0, result.1)
        }
    }
    
    func getAccounts(deviceId: String, completion: @escaping (_ accounts: [Account]?, _ error: String?) -> Void) {
        router.request(.getAccounts(deviceId: deviceId)) { data, response, error in
            let result = handleNetworkResponse(data: data, response: response, error: error, responseModelType: [Account].self)
            completion(result.0, result.1)
        }
    }
    
    func deleteAccount(id: String, completion: @escaping (_ account: Account?, _ error: String?) -> Void) {
        router.request(.deleteAccount(id: id)) { data, response, error in
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
                                                    thresholdValue: thresholdValue)) { data, response, error in
            let result = handleNetworkResponse(data: data, response: response, error: error, responseModelType: EulerNotificationHealth.self)
            completion(result.0, result.1)
        }
    }
    
    func getEulerNotificationHealth(deviceId: String, completion: @escaping (_ notifications: [EulerNotificationHealth]?, _ error: String?) -> Void) {
        router.request(.getEulerNotificationHealth(deviceId: deviceId)) { data, response, error in
            let result = handleNetworkResponse(data: data, response: response, error: error, responseModelType: [EulerNotificationHealth].self)
            completion(result.0, result.1)
        }
    }
    
    func putEulerNotificationHealth(id: String, thresholdValue: Float, completion: @escaping (_ notification: EulerNotificationHealth?, _ error: String?) -> Void) {
        router.request(.putEulerNotificationHealth(id: id, thresholdValue: thresholdValue)) { data, response, error in
            let result = handleNetworkResponse(data: data, response: response, error: error, responseModelType: EulerNotificationHealth.self)
            completion(result.0, result.1)
        }
    }
    
    func deleteEulerNotificationHealth(id: String, completion: @escaping (_ notification: EulerNotificationHealth?, _ error: String?) -> Void) {
        router.request(.deleteEulerNotificationHealth(id: id)) { data, response, error in
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
                                                supplyUpperThreshold: supplyUpperThreshold)) { data, response, error in
            let result = handleNetworkResponse(data: data, response: response, error: error, responseModelType: EulerNotificationIR.self)
            completion(result.0, result.1)
        }
    }
    
    func getEulerNotificationIR(deviceId: String, completion: @escaping (_ notifications: [EulerNotificationIR]?, _ error: String?) -> Void) {
        router.request(.getEulerNotificationIR(deviceId: deviceId)) { data, response, error in
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
                                                isActive: isActive)) { data, response, error in
            let result = handleNetworkResponse(data: data, response: response, error: error, responseModelType: EulerNotificationIR.self)
            completion(result.0, result.1)
        }
    }
    
    func deleteEulerNotificationIR(id: String, completion: @escaping (_ notification: EulerNotificationIR?, _ error: String?) -> Void) {
        router.request(.deleteEulerNotificationIR(id: id)) { data, response, error in
            let result = handleNetworkResponse(data: data, response: response, error: error, responseModelType: EulerNotificationIR.self)
            completion(result.0, result.1)
        }
    }
    
    //*********************************
    // Euler Account Method
    //*********************************
    
    func getEulerAccounts(address: String, completion: @escaping (_ accounts: [EulerAccount]?, _ error: String?) -> Void) {
        router.request(.getEulerAccount(address: address)) { data, response, error in
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
    
    func throbImageview(parentView: UIView, hiddenThrobber: Bool) {
//        if hiddenThrobber {
//            imageView.alpha = 0.8
//        }
//
//        UIView.animate(withDuration: 1.0, delay:0, options: [.repeat, .autoreverse], animations: {
//            imageView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
//        }, completion: nil)
//
        let imageView = UIImageView(frame: CGRect(x: -100, y: -100, width: 200, height: 200))
        imageView.alpha = 0
        imageView.image = UIImage(named: "YachtLogo")
        imageView.contentMode = .scaleAspectFit
        let transformLayer = CATransformLayer()
        var perspective = CATransform3DIdentity
        perspective.m34 = -1 / 500
        transformLayer.transform = perspective
        transformLayer.position = CGPoint(x: parentView.bounds.midX, y: parentView.bounds.midY)
        transformLayer.anchorPointZ = -100
        transformLayer.addSublayer(imageView.layer)
        parentView.layer.addSublayer(transformLayer)
        
        let fadeInAnim = CABasicAnimation(keyPath: "opacity")
        fadeInAnim.fromValue = 0
        fadeInAnim.toValue = 1
        fadeInAnim.duration = 1
        fadeInAnim.repeatCount = 1
        imageView.layer.add(fadeInAnim, forKey: "opacity")
   
        let anim = CABasicAnimation(keyPath: "transform")
        anim.fromValue = CATransform3DMakeRotation(0.8, 0, 1, 0)
        anim.toValue = CATransform3DMakeRotation(-0.8, 0, 1, 0)
        anim.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        anim.beginTime = 1
        anim.duration = 1
        anim.autoreverses = true
        anim.repeatCount = .greatestFiniteMagnitude
        imageView.layer.add(anim, forKey: "transform")
       
        
    }
    
    func stopThrob(imageView: UIImageView, hiddenThrobber: Bool) {
        if hiddenThrobber {
            imageView.alpha = 0
        }
        imageView.layer.removeAllAnimations()
    }
    
    func showErrorAlert(title: String, message: String, vc: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { _ in }))
        vc.present(alert, animated: true, completion: nil)
    }

}
