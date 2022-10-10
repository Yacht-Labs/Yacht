//
//  WalletBridge.swift
//  Yacht
//
//  Created by Henry Minden on 10/6/22.
//

import Foundation

@objc(WalletBridge)
class WalletBridge: RCTEventEmitter {

    public static var shared: WalletBridge?

    override init() {
        super.init()
        WalletBridge.shared = self
    }

    @objc
    func sendDeviceId(deviceId: String, withAccountIndex: Int) {
        sendEvent(withName: "onSendDeviceId", body: ["deviceId": deviceId, "accountIndex": withAccountIndex])
    }

    @objc
    func returnLedgerAccount(_ account: NSDictionary) {
        NotificationCenter.default.post(name: NSNotification.Name("return.ledger.account"), object: account)
    }
    
    @objc
    func returnLedgerDevice(_ device: NSDictionary) {
        NotificationCenter.default.post(name: NSNotification.Name("return.ledger.device"), object: device)
    }
    
    @objc
    func returnComponentLoaded() {
        NotificationCenter.default.post(name: NSNotification.Name("return.component.loaded"), object: nil)
    }

    override func supportedEvents() -> [String]! {
        return [
                "onSendDeviceId"
                ]
    }
    
    override static func requiresMainQueueSetup() -> Bool {
        return true
    }
    
}
