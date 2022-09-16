//
//  BuildConfiguration.swift
//  Yacht
//
//  Created by Henry Minden on 9/16/22.
//

import Foundation

enum Environment: String {
    case devDebug = "DEV-Debug"
    case stageDebug = "STAGE-Debug"
    case prodDebug = "PROD-Debug"
    
    case devRelease = "DEV-Release"
    case stageRelease = "STAGE-Release"
    case prodRelease = "PROD-Release"
}

class BuildConfiguration {
    static let shared = BuildConfiguration()
    var environment: Environment
    
    var network: NetworkEnvironment { 
            switch environment {
            case .devDebug, .devRelease:
                return NetworkEnvironment.localhost
            case .stageDebug, .stageRelease:
                return NetworkEnvironment.staging
            case .prodDebug, .prodRelease:
                return NetworkEnvironment.production
            }
        }
    
    init() {
        let currentConfiguration = Bundle.main.object(forInfoDictionaryKey: "Configuration") as! String
        environment = Environment(rawValue: currentConfiguration)!
    }
}
