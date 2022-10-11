//
//  LocalStorageManager.swift
//  Yacht
//
//  Created by Henry Minden on 8/26/22.
//

import Foundation
import CoreData

class LocalStorageManager {
    func setSelectedChainId(chainId: Int) {
        let defaults = UserDefaults.standard
        defaults.set(chainId, forKey: Constants.LocalStorage.chainId)
    }
    
    func getSelectedChainId() -> Int {
        let defaults = UserDefaults.standard
        return defaults.integer(forKey: Constants.LocalStorage.chainId)
    }
    
    func createAddressInCoreData(address: String, nickname: String, deviceId: String, id: String, isLedger: Bool) {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        guard let addressEntity = NSEntityDescription.entity(forEntityName: "Address", in: managedContext) else { return }
        let newAddress = NSManagedObject(entity: addressEntity, insertInto: managedContext)
        newAddress.setValue(address, forKeyPath: "address")
        newAddress.setValue(nickname, forKeyPath: "nickname")
        newAddress.setValue(deviceId, forKeyPath: "deviceId")
        newAddress.setValue(id, forKeyPath: "id")
        newAddress.setValue(true, forKeyPath: "isActive")
        newAddress.setValue(isLedger, forKeyPath: "isLedger")
        
        do {
            try managedContext.save()
        } catch {
            print(error)
        }
    }
}
