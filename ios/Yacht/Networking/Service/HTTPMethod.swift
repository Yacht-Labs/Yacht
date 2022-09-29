//
//  HTTPMethod.swift
//  YachtWallet
//
//  Created by Henry Minden on 5/4/22.
//

import Foundation
import Network

public enum HTTPMethod: String {
    case get    = "GET"
    case post   = "POST"
    case put    = "PUT"
    case patch  = "PATCH"
    case delete = "DELETE"
}
