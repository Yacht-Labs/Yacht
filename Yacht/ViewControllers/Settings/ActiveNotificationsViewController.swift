//
//  ActiveNotificationsViewController.swift
//  Yacht
//
//  Created by Henry Minden on 8/31/22.
//

import UIKit

class ActiveNotificationsViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var yachtImage: UIImageView!
    
    var eulerHealthNotifications: [EulerNotificationHealth] = []
    var eulerIRNotifications: [EulerNotificationIR] = []
    var accounts: [Account] = []
    var eulerTokens: [EulerToken] = []
    var deviceId: String?
    let networkManager = NetworkManager()
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.forceUpdateNavBar()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        yachtImage.alpha = 0
        
        navigationItem.title = "Active Notifications"
        navigationController?.navigationBar.prefersLargeTitles = true
        self.tableView.contentInsetAdjustmentBehavior = .never
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        guard let deviceId = appDelegate.deviceId else {
            networkManager.showErrorAlert(title: "Notifications Disabled", message: "Notifications must be enabled to use this app. Please turn on notifications in settings and hard restart the app", vc: self)
            return
        }
        self.deviceId = deviceId
        getAccounts(deviceId: deviceId)

    }
        
    func getAccounts(deviceId: String) {
        networkManager.throbImageview(imageView: yachtImage, hiddenThrobber: true)
        networkManager.getAccounts(deviceId: deviceId) { accounts, error in
            if error == nil {
                guard let accounts = accounts else {
                    DispatchQueue.main.async {
                        self.networkManager.stopThrob(imageView: self.yachtImage, hiddenThrobber: true)
                    }
                    return
                }
                if !accounts.isEmpty {
                    self.accounts = accounts
                    self.getTokens(deviceId: deviceId)
                } else {
                    self.networkManager.stopThrob(imageView: self.yachtImage, hiddenThrobber: true)
                }
                    
            } else {
                DispatchQueue.main.async {
                    self.networkManager.stopThrob(imageView: self.yachtImage, hiddenThrobber: true)
                    self.networkManager.showErrorAlert(title: "Server Error", message: "Failed to get accounts for device", vc: self)
                }
            }
        }
    }
    
    func getTokens(deviceId: String) {
        networkManager.getEulerTokens { tokens, error in
            if error == nil {
                self.eulerTokens = tokens ?? []
            } else {
                DispatchQueue.main.async {
                    self.networkManager.showErrorAlert(title: "Server Error", message: "Failed to get Euler tokens", vc: self)
                }
            }
            self.getEulerHealthNotifications(deviceId: deviceId)
        }
    }
    
    func getEulerHealthNotifications(deviceId: String) {
        networkManager.getEulerNotificationHealth(deviceId: deviceId) { notifications, error in
            if error == nil {
                DispatchQueue.main.async {
                    self.eulerHealthNotifications = notifications ?? []
                    self.tableView.reloadData()
                }
            } else {
                DispatchQueue.main.async {
                    self.networkManager.showErrorAlert(title: "Server Error", message: "Failed to get Euler health notifications for device", vc: self)
                }
            }
            self.getEulerIRNotifications(deviceId: deviceId)
        }
    }
    
    func getEulerIRNotifications(deviceId: String) {
        networkManager.getEulerNotificationIR(deviceId: deviceId) { notifications, error in
            if error == nil {
                DispatchQueue.main.async {
                    self.eulerIRNotifications = notifications ?? []
                    self.networkManager.stopThrob(imageView: self.yachtImage, hiddenThrobber: true)
                    self.tableView.reloadData()
                }
            } else {
                DispatchQueue.main.async {
                    self.networkManager.stopThrob(imageView: self.yachtImage, hiddenThrobber: true)
                    self.networkManager.showErrorAlert(title: "Server Error", message: "Failed to get Euler IR notifications for device", vc: self)
                }
            }
        }
    }
}

extension ActiveNotificationsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return eulerHealthNotifications.count
        } else if section == 1 {
            return eulerIRNotifications.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "ActiveNotificationTableViewCell") as? ActiveNotificationTableViewCell {
                let notification = eulerHealthNotifications[indexPath.row]
                let account = accounts.first(where: { $0.id == notification.accountId })
                var subAccount: String
                if notification.subAccountId == "0" {
                    subAccount = "Main"
                } else {
                    subAccount = "Sub \(notification.subAccountId ?? "??")"
                }
                cell.notificationType.text = (account?.name ?? "Unknown Account") + " - " + subAccount
                return cell
            }
            
        } else if indexPath.section == 1 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "ActiveNotificationTableViewCell") as? ActiveNotificationTableViewCell {
                let notification = eulerIRNotifications[indexPath.row]
                let token = eulerTokens.first(where: { $0.address == notification.tokenAddress })
                cell.notificationType.text = token?.symbol
                return cell
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = Constants.Colors.viewBackgroundColor
        let titleLabel = UILabel(frame: CGRect(x: 20, y: 0, width: self.view.bounds.width, height: 38))
        headerView.addSubview(titleLabel)
        
        
        if section == 0 {
            if eulerHealthNotifications.isEmpty {
                titleLabel.textColor = Constants.Colors.lightGray
                titleLabel.font = UIFont(name: "Akkurat-Regular", size: 16)
                titleLabel.text = "No active Euler health notifications"
            } else {
                titleLabel.textColor = Constants.Colors.deepRed
                titleLabel.font = UIFont(name: "Akkurat-Bold", size: 22)
                titleLabel.text = "Euler Health Score"
            }
            
        } else if section == 1 {
            if eulerIRNotifications.isEmpty {
                titleLabel.textColor = Constants.Colors.lightGray
                titleLabel.font = UIFont(name: "Akkurat-Regular", size: 16)
                titleLabel.text = "No active Euler interest notifications"
            } else {
                titleLabel.textColor = Constants.Colors.deepRed
                titleLabel.font = UIFont(name: "Akkurat-Bold", size: 22)
                titleLabel.text = "Euler Interest Rate"
            }
        }
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let storyboard = UIStoryboard(name: "Addresses", bundle: nil)
            let vc = storyboard.instantiateViewController(identifier: "HealthNotificationViewController") as HealthNotificationViewController
            let notification = eulerHealthNotifications[indexPath.row]
            let account = accounts.first(where: { $0.id == notification.accountId })
            
            vc.subAccountId = notification.subAccountId
            vc.accountId = notification.accountId
            vc.deviceId = self.deviceId
            vc.accountName = account?.name ?? "??"
            self.navigationController?.pushViewController(vc, animated: true)
            
        } else if indexPath.section == 1 {
            let storyboard = UIStoryboard(name: "Addresses", bundle: nil)
            let vc = storyboard.instantiateViewController(identifier: "SetIRNotificationViewController") as SetIRNotificationViewController
            let notification = eulerIRNotifications[indexPath.row]
            let token = eulerTokens.first(where: { $0.address == notification.tokenAddress })
            
            vc.tokenAddress = token?.address ?? "0x0000000000000000000000000000000000000000"
            vc.supplyAPY = token?.supplyAPY ?? 0
            vc.borrowAPY = token?.borrowAPY ?? 0
            vc.symbolValue = token?.symbol ?? ""
            vc.deviceId = self.deviceId
            vc.token = token ?? nil
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            networkManager.throbImageview(imageView: yachtImage, hiddenThrobber: true)
            if indexPath.section == 0 {
                let notification = eulerHealthNotifications[indexPath.row]
                networkManager.deleteEulerNotificationHealth(id: notification.id) { notification, error in
                    if error == nil {
                        DispatchQueue.main.async {
                            self.eulerHealthNotifications.remove(at: indexPath.row)
                            tableView.deleteRows(at: [indexPath], with: .fade)
                            tableView.reloadData()
                            self.networkManager.stopThrob(imageView: self.yachtImage, hiddenThrobber: true)
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.networkManager.showErrorAlert(title: "Server Error", message: "Failed to delete notification", vc: self)
                            self.networkManager.stopThrob(imageView: self.yachtImage, hiddenThrobber: true)
                        }
                    }
                    
                }
            } else if indexPath.section == 1 {
                let notification = eulerIRNotifications[indexPath.row]
                networkManager.deleteEulerNotificationIR(id: notification.id) { notification, error in
                    if error == nil {
                        DispatchQueue.main.async {
                            self.eulerIRNotifications.remove(at: indexPath.row)
                            tableView.deleteRows(at: [indexPath], with: .fade)
                            tableView.reloadData()
                            self.networkManager.stopThrob(imageView: self.yachtImage, hiddenThrobber: true)
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.networkManager.showErrorAlert(title: "Server Error", message: "Failed to delete notification", vc: self)
                            self.networkManager.stopThrob(imageView: self.yachtImage, hiddenThrobber: true)
                        }
                    }
                }
            }
        }
    }
}
