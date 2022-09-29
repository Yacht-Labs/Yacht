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
        
        toastView = ToastView.init(frame: CGRect(x: self.view.frame.origin.x, y: self.view.bounds.height, width: self.view.frame.size.width, height: 80))
        toastView?.parentViewHeight = self.view.bounds.height
        self.view.addSubview(toastView!)
        
        let environmentText: String
        switch BuildConfiguration.shared.environment {
        case .devDebug, .devRelease:
            environmentText = "DEV"
        case .stageDebug, .stageRelease:
            environmentText = "STAGE"
        case .prodDebug, .prodRelease:
            environmentText = ""
        }
        
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "??"
        let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "??"

        let versionView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 64))
        let versionLabel = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 64))
        versionLabel.textAlignment = .center
        versionLabel.font = UIFont(name: "Akkurat-Bold", size: 14)
        versionLabel.textColor = Constants.Colors.lightGray
        versionLabel.text = "Yacht v\(version) (\(build)) \(environmentText)"
        versionView.addSubview(versionLabel)
        tableView.tableFooterView = versionView
    
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
        return 5
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "SettingNetworkTableViewCell") as? SettingNetworkTableViewCell {
                cell.type.text = "Network:"
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
            if let cell = tableView.dequeueReusableCell(withIdentifier: "SettingNetworkTableViewCell") as? SettingNetworkTableViewCell {
                cell.type.text = "DeFi Protocol:"
                cell.network.text = "Euler"
                return cell
            }
        }
        if indexPath.row == 2 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "SettingNotificationTableViewCell") as? SettingNotificationTableViewCell {
                return cell
            }
        }
        if indexPath.row == 3 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsSocialTableViewCell") as? SettingsSocialTableViewCell {
                cell.socialNetwork.text = "Join our Discord"
                cell.socialImage.image = UIImage(named: "Discord")
                return cell
            }
        }
        if indexPath.row == 4 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsSocialTableViewCell") as? SettingsSocialTableViewCell {
                cell.socialNetwork.text = "Follow us on Twitter"
                cell.socialImage.image = UIImage(named: "Twitter")
                return cell
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let storyboard = UIStoryboard(name: "Settings", bundle: nil)
            let vc = storyboard.instantiateViewController(identifier: "NetworkSelectViewController") as NetworkSelectViewController
            vc.chainId = chainId
            self.navigationController?.pushViewController(vc, animated: true)
            
        } else if indexPath.row == 1 {
            let storyboard = UIStoryboard(name: "Settings", bundle: nil)
            let vc = storyboard.instantiateViewController(identifier: "ProtocolSelectViewController") as ProtocolSelectViewController
            self.navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.row == 2 {
            let storyboard = UIStoryboard(name: "Settings", bundle: nil)
            let vc = storyboard.instantiateViewController(identifier: "ActiveNotificationsViewController") as ActiveNotificationsViewController
            self.navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.row == 3 {
            if let url = URL(string: "https://discord.gg/hqt5PNkxKN") {
                UIApplication.shared.open(url)
            }
        } else if indexPath.row == 4 {
            let appURL = URL(string: "twitter://user?screen_name=Yacht_Labs")
            guard let appURL = appURL else {
                return
            }
            if UIApplication.shared.canOpenURL(appURL) {
                UIApplication.shared.open(appURL)
            } else {
                let webURL = URL(string: "https://twitter.com/Yacht_Labs")
                guard let webURL = webURL else {
                    return
                }
                UIApplication.shared.open(webURL)
            }
        }
    }
}
