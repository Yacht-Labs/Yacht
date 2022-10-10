//
//  LedgerAddressSelectViewController.swift
//  Yacht
//
//  Created by Henry Minden on 10/10/22.
//

import UIKit

class LedgerAddressSelectViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var topMessage: UILabel!
    @IBOutlet weak var continueButton: UIButton!
    var deviceId: String?
    var currentAccountIndex: Int = 0
    var addresses: [(Int, String, String)] = []
    var selectedAddresses: [Int] = []
    let maxAccounts: Int = 10
    let networkManager = NetworkManager()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        canContinue(status: false)
        let font = UIFont(name: "Akkurat-Bold", size: 18)
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font!,
            .foregroundColor: Constants.Colors.viewBackgroundColor
        ]
        continueButton.setAttributedTitle(NSAttributedString(string: "Continue", attributes: attributes), for: .normal)
        
        navigationItem.title = "Select Ledger Accounts"
        navigationController?.navigationBar.prefersLargeTitles = true
        tableView.contentInsetAdjustmentBehavior = .never
        
        NotificationCenter.default.addObserver(self, selector: #selector(wbReturnLedgerAccount(_:)), name: NSNotification.Name("return.ledger.account"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(wbReturnComponentLoaded(_:)), name: NSNotification.Name("return.component.loaded"), object: nil)
        
        self.view.addSubview(getReactRootView(moduleName: "LedgerAddressSelect"))
        
        networkManager.throbImageview(parentView: self.view)
    }
    
    private func canContinue(status: Bool) {
        if status {
            UIView.animate(withDuration: 0.8, delay: 0) {
                self.continueButton.alpha = 1
            } completion: { _ in
                self.continueButton.isEnabled = true
            }
        } else {
            self.continueButton.isEnabled = false
            UIView.animate(withDuration: 0.8, delay: 0) {
                self.continueButton.alpha = 0
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = continueButton.bounds
        gradientLayer.colors = [Constants.Colors.mediumRed.cgColor, Constants.Colors.deepRed.cgColor]
        continueButton.layer.insertSublayer(gradientLayer, at: 0)
        
        continueButton.tintColor = Constants.Colors.viewBackgroundColor
        continueButton.clipsToBounds = true
        continueButton.layer.cornerRadius = 24
    }
    
    @objc func wbReturnComponentLoaded(_ notification: Notification) {
        WalletBridge.shared!.sendDeviceId(deviceId: deviceId!, withAccountIndex: currentAccountIndex)
    }
    
    @objc func wbReturnLedgerAccount(_ notification: Notification) {
        guard let parsedDictionary = notification.object as? [String: Any],
              let payload = parsedDictionary["payload"] as? [String: Any] else { return }
        
        guard let address = payload["address"] as? String,
              let accountIndex = payload["accountIndex"] as? Int,
              let path = payload["path"] as? String else { return }
        addresses.append((accountIndex, address, path))

        DispatchQueue.main.async {
            self.topMessage.text = "Select the accounts you would like to manage on Yacht. SAFE: Your private keys will never leave your Ledger device."
            self.tableView.reloadData()
        }
        
        currentAccountIndex += 1
        
        if currentAccountIndex < maxAccounts {
            WalletBridge.shared!.sendDeviceId(deviceId: deviceId!, withAccountIndex: currentAccountIndex)
        } else {
            DispatchQueue.main.async {
                self.networkManager.stopThrob()
                
            }
        }
    }
}

extension LedgerAddressSelectViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if selectedAddresses[indexPath.row] == 1 {
            selectedAddresses[indexPath.row] = 0
        } else {
            selectedAddresses[indexPath.row] = 1
        }
        
        if selectedAddresses.contains(1) {
            canContinue(status: true)
        } else {
            canContinue(status: false)
        }
        
        tableView.reloadRows(at: [indexPath], with: .none)
    }
    
}

extension LedgerAddressSelectViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return addresses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let addressData = addresses[indexPath.row]
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "LedgerAddressSelectTableViewCell", for: indexPath) as? LedgerAddressSelectTableViewCell else {
            return UITableViewCell()
        }
        
        cell.accountName.text = "Account " + String(addressData.0 + 1)
        cell.address.text = addressData.1
        
        if selectedAddresses[indexPath.row] == 1 {
            cell.check.alpha = 1
        } else {
            cell.check.alpha = 0
        }
    
        return cell
    }
    
}
