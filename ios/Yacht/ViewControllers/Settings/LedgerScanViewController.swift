//
//  LedgerScanViewController.swift
//  Yacht
//
//  Created by Henry Minden on 10/6/22.
//

import UIKit
import React

class LedgerScanViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var topMessage: UILabel!
    @IBOutlet weak var yachtImage: UIImageView!
    
    var devices: [(String, String)] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Scanning for Devices"
        navigationController?.navigationBar.prefersLargeTitles = true
        tableView.contentInsetAdjustmentBehavior = .never
        
        tableView.delegate = self
        tableView.dataSource = self
        
        self.view.addSubview(getReactRootView(moduleName: "LedgerConnect"))
        
        NotificationCenter.default.addObserver(self, selector: #selector(wbReturnLedgerDevice(_:)), name: NSNotification.Name("return.ledger.device"), object: nil)
        
        let networkManager = NetworkManager()
        networkManager.throbImageview(parentView: self.view, hiddenThrobber: true)
        
    }
    
    @objc func wbReturnLedgerDevice(_ notification: Notification) {

        guard let parsedDictionary = notification.object as? [String: Any],
              let payload = parsedDictionary["payload"] as? [String: Any],
              let descriptor = payload["descriptor"] as? [String: Any],
              let localName = descriptor["localName"] as? String,
              let id = descriptor["id"] as? String else { return }
        print(localName, id)
        devices.append((localName, id))
        DispatchQueue.main.async {
            self.topMessage.text = "Select your device below"
            self.tableView.reloadData()
        }
        
    }

}

extension LedgerScanViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let deviceData = devices[indexPath.row]
        let deviceId = deviceData.1
        print(deviceId)
    }
}

extension LedgerScanViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return devices.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let deviceData = devices[indexPath.row]
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "LedgerScanTableViewCell", for: indexPath) as? LedgerScanTableViewCell else {
            return UITableViewCell()
        }
        
        cell.deviceName.text = deviceData.0
        
        return cell
    }
    
}
