//
//  NetworkManager.swift
//  YachtWallet
//
//  Created by Henry Minden on 5/4/22.
//

import Foundation

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
    static let environment: NetworkEnvironment = .localhost
    private let router = Router<NotificationServiceAPI>()
    
    func getEulerTokens(completion: @escaping (_ tokens: [EulerToken]?, _ error: String?) -> Void) {
        router.request(.getEulerTokens) { data, response, error in
            let result = handleNetworkResponse(data: data, response: response, error: error, responseModelType: [EulerToken].self)
            completion(result.0, result.1)
        }
    }
    
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
        case 401...500: return .failure(NetworkResponse.authenticationError.rawValue)
        case 501...599: return .failure(NetworkResponse.badRequest.rawValue)
        case 600: return .failure(NetworkResponse.outdated.rawValue)
        default: return .failure(NetworkResponse.failed.rawValue)
        }
    }

}
