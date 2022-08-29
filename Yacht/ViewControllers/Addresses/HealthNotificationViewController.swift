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
    var accountId: String?
    var deviceId: String?
    
    @IBAction func saveTouched(_ sender: Any) {
        guard let accountId = accountId,
            let deviceId = deviceId else {
            return
        }
        let networkManager = NetworkManager()
        self.saveButton.isEnabled = false
        networkManager.throbImageview(imageView: yachtImage, hiddenThrobber: true)
        networkManager.postEulerNotificationHealth(accountId: accountId, deviceId: deviceId, thresholdValue: String(round(slider.value * 100) / 100.0)) { notification, error in
            if error == nil {
                DispatchQueue.main.async {
                    networkManager.stopThrob(imageView: self.yachtImage, hiddenThrobber: true)
                    self.saveButton.isEnabled = true
                }
            } else {
                DispatchQueue.main.async {
                    networkManager.stopThrob(imageView: self.yachtImage, hiddenThrobber: true)
                    self.saveButton.isEnabled = true
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let networkManager = NetworkManager()
        if let deviceId = deviceId {
            networkManager.getEulerNotificationHealth(deviceId: deviceId) { notifications, error in
                if error == nil {          
                    guard let notifications = notifications else {
                        return
                    }
                    for notification in notifications {
                        if notification.accountId == self.accountId {
                            DispatchQueue.main.async {
                                self.slider.setValue(Float(notification.thresholdValue) ?? 1, animated: true)
                            }
                        }
                    }
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
        yachtImage.alpha = 0
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

    @objc func onSlide(){
        healthScoreLabel.text = String(round(slider.value * 100) / 100.0)
    }


}
