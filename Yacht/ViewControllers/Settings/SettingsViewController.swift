//
//  SettingsViewController.swift
//  Yacht
//
//  Created by Henry Minden on 8/25/22.
//

import UIKit

class SettingsViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var toastView: ToastView?
    var chainId: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        toastView = ToastView.init(frame: CGRect(x: self.view.frame.origin.x, y: -80, width: self.view.frame.size.width, height: 80))
        self.view.addSubview(toastView!)
    
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getCurrentChain()
    }
    
    func getCurrentChain() {
        let lsm = LocalStorageManager()
        chainId = lsm.getSelectedChainId()
        
        // Set chainId to Ethereum Mainnet if nothing is set
        if chainId == 0 {
            lsm.setSelectedChainId(chainId: 1)
            chainId = 1
        }
        tableView.reloadData()
    }
    
}

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "SettingNetworkTableViewCell") as? SettingNetworkTableViewCell {
                if chainId == 0 {
                    cell.network.text = ""
                } else {
                    guard let networkName = Constants.evmChainNames.first(where: { $0.0 == chainId })?.1 else {
                        return cell
                    }
                    cell.network.text = networkName
                }
                return cell
            }
        }
        if indexPath.row == 1 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "SettingNotificationTableViewCell") as? SettingNotificationTableViewCell {
                return cell
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            toastView?.titleLabel.text = "Coming Soon"
            toastView?.bodyText.text = "Support for additional networks is on our roadmap! Follow us on twitter @Yacht_Labs for release updates"
            toastView?.showToast()
            
        } else if indexPath.row == 1 {
            let storyboard = UIStoryboard(name: "Settings", bundle: nil)
            let vc = storyboard.instantiateViewController(identifier: "ActiveNotificationsViewController") as ActiveNotificationsViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }
                    
    }
}