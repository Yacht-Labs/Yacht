//
//  GetReactRootView.swift
//  Yacht
//
//  Created by Henry Minden on 10/6/22.
//

import Foundation
import React

public func getReactRootView(moduleName: String) -> RCTRootView {
    
    var js: URL?
    switch BuildConfiguration.shared.environment {
    case .devDebug, .stageDebug, .prodDebug, .debug:
        let urlString = "http://" + Constants.Environment.localhost + "/index.bundle?platform=ios"
        js = URL(string: urlString)
    case .devRelease, .stageRelease, .prodRelease, .release:
        js = RCTBundleURLProvider.sharedSettings().jsBundleURL(forBundleRoot: "index", fallbackExtension: nil)
    }

    let rootView = RCTRootView(
        bundleURL: js!,
        moduleName: moduleName,
        initialProperties: nil,
        launchOptions: nil
    )
    
    return rootView
}
