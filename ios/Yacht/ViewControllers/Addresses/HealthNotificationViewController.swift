//
//  HealthNotificationViewController.swift
//  Yacht
//
//  Created by Henry Minden on 8/25/22.
//

import UIKit

class HealthNotificationViewController: UIViewController {
    @IBOutlet weak var healthScoreLabel: UILabel!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var yachtImage: UIImageView!
    @IBOutlet weak var accountNameLabel: UILabel!
    @IBOutlet weak var snoozedLabel: UILabel!
    
    var accountId: String?
    var subAccountId: String?
    var deviceId: String?
    var accountName: String?
    var notificationId: String?
    var toastView: ToastView?
    let networkManager = NetworkManager()
    
    @IBAction func saveTouched(_ sender: Any) {
        guard let accountId = accountId,
            let subAccountId = subAccountId,
            let deviceId = deviceId else {
            return
        }
        
        if deviceId == Constants.Demo.demoDeviceId {
            toastView?.titleLabel.text = "Notifications Disabled"
            toastView?.bodyText.text = "Notifications must be enabled in order to receive alerts. Turn on notifications and hard restart app in order to enable active notifications"
            toastView?.showToast()
            return 
        }
        
        self.saveButton.isEnabled = false
        networkManager.throbImageview(parentView: self.view)
        
        if let notificationId = notificationId {
            // Update existing notification
            networkManager.putEulerNotificationHealth(id: notificationId, thresholdValue: (round(slider.value * 100) / 100.0)) { notification, error in
                if error != nil {
                    DispatchQueue.main.async { [self] in
                        networkManager.showErrorAlert(title: "Server Error", message: "Unable to update notification", vc: self)
                        networkManager.stopThrob()
                        self.saveButton.isEnabled = true
                    }
                } else {
                    DispatchQueue.main.async {
                        self.notificationId = notification?.id
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }
        } else {
            // Create new notification
            networkManager.postEulerNotificationHealth(accountId: accountId, subAccountId: subAccountId, deviceId: deviceId, thresholdValue: (round(slider.value * 100) / 100.0)) { notification, error in
                if error != nil {
                    DispatchQueue.main.async { [self] in
                        networkManager.showErrorAlert(title: "Server Error", message: "Unable to create notification", vc: self)
                        networkManager.stopThrob()
                        self.saveButton.isEnabled = true
                    }
                } else {
                    DispatchQueue.main.async {
                        self.notificationId = notification?.id
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        snoozedLabel.alpha = 0
        
        var subAccount: String
        if subAccountId == "0" {
            subAccount = "Main"
        } else {
            subAccount = "Sub \(subAccountId ?? "??")"
        }
        
        toastView = ToastView.init(frame: CGRect(x: self.view.frame.origin.x, y: self.view.bounds.height, width: self.view.frame.size.width, height: 80))
        toastView?.parentViewHeight = self.view.bounds.height
        self.view.addSubview(toastView!)
        
        accountNameLabel.text = (accountName ?? "Unknown Account") + " - " + subAccount
        yachtImage.alpha = 0
        
        self.saveButton.isEnabled = false
        if let deviceId = deviceId {
            networkManager.getEulerNotificationHealth(deviceId: deviceId) { notifications, error in
                if error == nil {          
                    guard let notifications = notifications else {
                        return
                    }
                    for notification in notifications {
                        // See if there is any active notification matching current account
                        if notification.accountId == self.accountId && notification.isActive && notification.subAccountId == self.subAccountId {
                            DispatchQueue.main.async {
                                if notification.seen {
                                    self.snoozedLabel.alpha = 1
                                    
                                    let font = UIFont(name: "Akkurat-Bold", size: 12)
                                    let attributes: [NSAttributedString.Key: Any] = [
                                        .font: font!,
                                        .foregroundColor: Constants.Colors.viewBackgroundColor
                                    ]
                                    self.saveButton.setAttributedTitle(NSAttributedString(string: "Reset", attributes: attributes), for: .normal)
                                }
                                self.saveButton.isEnabled = true
                                self.notificationId = notification.id
                                self.slider.setValue(notification.thresholdValue , animated: true)
                                self.healthScoreLabel.text = String(notification.thresholdValue)
                            }
                        }
                    }
                }
                DispatchQueue.main.async {
                    self.saveButton.isEnabled = true
                }
            }
        }
        
        view.backgroundColor = Constants.Colors.viewBackgroundColor
        navigationItem.title = "Health Score Notification"
        healthScoreLabel.text = String(round(slider.value * 100) / 100.0)
        slider.addTarget(self, action: #selector(onSlide), for: UIControl.Event.valueChanged)
        
        let font = UIFont(name: "Akkurat-Bold", size: 18)
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font!,
            .foregroundColor: Constants.Colors.viewBackgroundColor
        ]
        saveButton.setAttributedTitle(NSAttributedString(string: "Save", attributes: attributes), for: .normal)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = saveButton.bounds
        gradientLayer.colors = [Constants.Colors.mediumRed.cgColor, Constants.Colors.deepRed.cgColor]
        saveButton.layer.insertSublayer(gradientLayer, at: 0)
        
        saveButton.tintColor = Constants.Colors.viewBackgroundColor
        saveButton.clipsToBounds = true
        saveButton.layer.cornerRadius = 24
    }

    @objc func onSlide(){
        healthScoreLabel.text = String(round(slider.value * 100) / 100.0)
    }


}
