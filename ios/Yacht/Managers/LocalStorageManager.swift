//
//  LocalStorageManager.swift
//  Yacht
//
//  Created by Henry Minden on 8/26/22.
//

import Foundation

class LocalStorageManager {
    func setSelectedChainId(chainId: Int) {
        let defaults = UserDefaults.standard
        defaults.set(chainId, forKey: Constants.LocalStorage.chainId)
    }
    
    func getSelectedChainId() -> Int {
        let defaults = UserDefaults.standard
        return defaults.integer(forKey: Constants.LocalStorage.chainId)
    }
}
