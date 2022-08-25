//
//  EndPointType.swift
//  YachtWallet
//
//  Created by Henry Minden on 5/4/22.
//

import Foundation

protocol EndPointType {
    var baseURL: URL { get }
    var path: String { get }
    var httpMethod: HTTPMethod { get }
    var task: HTTPTask { get }
    var headers: HTTPHeaders? { get }
}
