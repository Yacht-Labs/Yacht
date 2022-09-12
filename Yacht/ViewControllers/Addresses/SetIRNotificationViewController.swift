//
//  SetIRNotificationViewController.swift
//  Yacht
//
//  Created by Henry Minden on 8/30/22.
//

import UIKit

class SetIRNotificationViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var yachtImage: UIImageView!
    var accountId: String?
    var deviceId: String?
    var notificationId: String?
    var tokenAddress: String?
    var supplyAPY: Double = 0
    var borrowAPY: Double = 0
    var symbolValue: String?
    var numberFormatter: NumberFormatter = NumberFormatter()
    
    var supplyUpperThreshold: Int = 20
    var supplyLowerThreshold: Int = 20
    var borrowUpperThreshold: Int = 20
    var borrowLowerThreshold: Int = 20
    
    @IBAction func saveTouched(_ sender: Any) {
      
        guard let accountId = accountId,
            let deviceId = deviceId,
            let tokenAddress = tokenAddress else {
            return
        }
        let networkManager = NetworkManager()
        self.saveButton.isEnabled = false
        networkManager.throbImageview(imageView: yachtImage, hiddenThrobber: true)
        
        if let notificationId = notificationId {
            // Update existing notification
            networkManager.putEulerNotificationIR(id: notificationId,
                                                  borrowAPY: Float(borrowAPY),
                                                  supplyAPY: Float(supplyAPY),
                                                  borrowLowerThreshold: borrowLowerThreshold,
                                                  borrowUpperThreshold: borrowUpperThreshold,
                                                  supplyLowerThreshold: supplyLowerThreshold,
                                                  supplyUpperThreshold: supplyUpperThreshold,
                                                  isActive: true) { notification, error in
                if error != nil {
                    DispatchQueue.main.async {
                        networkManager.showErrorAlert(title: "Server Error", message: "Unable to update notification", vc: self)
                    }
                }
                DispatchQueue.main.async {
                    networkManager.stopThrob(imageView: self.yachtImage, hiddenThrobber: true)
                    self.saveButton.isEnabled = true
                }
            }
            
        } else {
            // Create new notification
            networkManager.postEulerNotificationIR(accountId: accountId,
                                                   deviceId: deviceId,
                                                   tokenAddress: tokenAddress,
                                                   borrowAPY: Float(borrowAPY),
                                                   supplyAPY: Float(supplyAPY),
                                                   borrowLowerThreshold: borrowLowerThreshold,
                                                   borrowUpperThreshold: borrowUpperThreshold,
                                                   supplyLowerThreshold: supplyLowerThreshold,
                                                   supplyUpperThreshold: supplyUpperThreshold) { notification, error in
                if error != nil {
                    DispatchQueue.main.async {
                        networkManager.showErrorAlert(title: "Server Error", message: "Unable to create notification", vc: self)
                    }
                } else {
                    self.notificationId = notification?.id
                }
                DispatchQueue.main.async {
                    networkManager.stopThrob(imageView: self.yachtImage, hiddenThrobber: true)
                    self.saveButton.isEnabled = true
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        yachtImage.alpha = 0
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Euler Interest Notification"
        self.tableView.contentInsetAdjustmentBehavior = .never
        
        let font = UIFont(name: "Akkurat-Bold", size: 18)
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font!,
            .foregroundColor: Constants.Colors.viewBackgroundColor
        ]
        saveButton.setAttributedTitle(NSAttributedString(string: "Save", attributes: attributes), for: .normal)
        
        self.saveButton.isEnabled = false
        let networkManager = NetworkManager()
        networkManager.throbImageview(imageView: yachtImage, hiddenThrobber: true)
        if let deviceId = deviceId {
            networkManager.getEulerNotificationIR(deviceId: deviceId) { notifications, error in
                if error == nil {
                    guard let notifications = notifications else {
                        return
                    }
                    for notification in notifications {
                        // See if there is an active notification matching the selected token address
                        if notification.tokenAddress == self.tokenAddress && notification.isActive  {
                            DispatchQueue.main.async {
                                self.notificationId = notification.id
                                
                                self.borrowUpperThreshold = notification.borrowUpperThreshold ?? 0
                                self.borrowLowerThreshold = notification.borrowLowerThreshold ?? 0
                                self.supplyUpperThreshold = notification.supplyUpperThreshold ?? 0
                                self.supplyLowerThreshold = notification.supplyLowerThreshold ?? 0
                                self.tableView.reloadData()
                            }
                        }
                    }
                }
                DispatchQueue.main.async {
                    self.saveButton.isEnabled = true
                    networkManager.stopThrob(imageView: self.yachtImage, hiddenThrobber: true)
                }
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = saveButton.bounds
        gradientLayer.colors = [Constants.Colors.mediumRed.cgColor, Constants.Colors.deepRed.cgColor]
        saveButton.layer.insertSublayer(gradientLayer, at: 0)
        
        saveButton.tintColor = Constants.Colors.viewBackgroundColor
        saveButton.clipsToBounds = true
        saveButton.layer.cornerRadius = 24
    }
    
}

extension SetIRNotificationViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                if let cell = tableView.dequeueReusableCell(withIdentifier: "NotifyThresholdTableViewCell") as? NotifyThresholdTableViewCell {
                    cell.delegate = self
                    cell.apy = Float(supplyAPY)
                    cell.value = supplyLowerThreshold
                    cell.type = .supplyLower
                    return cell
                }
            } else if indexPath.row == 1 {
                if let cell = tableView.dequeueReusableCell(withIdentifier: "NotifyThresholdTableViewCell") as? NotifyThresholdTableViewCell {
                    cell.delegate = self
                    cell.apy = Float(supplyAPY)
                    cell.value = supplyUpperThreshold
                    cell.type = .supplyUpper
                    return cell
                }
            }
        } else if indexPath.section == 1 {
            if indexPath.row == 0 {
               if let cell = tableView.dequeueReusableCell(withIdentifier: "NotifyThresholdTableViewCell") as? NotifyThresholdTableViewCell {
                   cell.delegate = self
                   cell.apy = Float(borrowAPY)
                   cell.value = borrowLowerThreshold
                   cell.type = .borrowLower
                   return cell
               }
            } else if indexPath.row == 1 {
               if let cell = tableView.dequeueReusableCell(withIdentifier: "NotifyThresholdTableViewCell") as? NotifyThresholdTableViewCell {
                   cell.delegate = self
                   cell.apy = Float(borrowAPY)
                   cell.value = borrowUpperThreshold
                   cell.type = .borrowUpper
                   return cell
               }
           }
        }
         
  
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = Constants.Colors.viewBackgroundColor
        let titleLabel = UILabel(frame: CGRect(x: 20, y: 0, width: self.view.bounds.width, height: 64))
        headerView.addSubview(titleLabel)
        titleLabel.textColor = Constants.Colors.deepRed
        titleLabel.font = UIFont(name: "Akkurat-Bold", size: 20)
        
        numberFormatter.numberStyle = .percent
        numberFormatter.maximumFractionDigits = 2

        if section == 0 {
            titleLabel.text = "Current " + (symbolValue ?? "??") + " Supply APY: " + (numberFormatter.string(from: NSNumber(value: (supplyAPY / 100))) ?? "??")
        } else if section == 1 {
            titleLabel.text = "Current " + (symbolValue ?? "??") + " Borrow APY: " + (numberFormatter.string(from: NSNumber(value: (borrowAPY / 100))) ?? "??")
        }
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 64
    }
    
}

extension SetIRNotificationViewController: NotifyThresholdTableViewCellDelegate {
    func sliderValueChanged(type: NotifyThresholdType, value: Int) {
        switch type {
        case .supplyLower:
            supplyLowerThreshold = value
        case .supplyUpper:
            supplyUpperThreshold = value
        case .borrowLower:
            borrowLowerThreshold = value
        case .borrowUpper:
            borrowUpperThreshold = value
        }
    }
}
