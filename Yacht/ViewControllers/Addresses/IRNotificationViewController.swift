//
//  IRNotificationViewController.swift
//  Yacht
//
//  Created by Henry Minden on 8/25/22.
//

import UIKit

enum IRType {
    case asset
    case deposit
    case loan
}

class IRNotificationViewController: UIViewController {
    var irNotificationType: IRType = .asset
    @IBOutlet weak var yachtImage: UIImageView!
    
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var symbol: UILabel!
    
    @IBOutlet weak var changeByTop: UILabel!
    @IBOutlet weak var changePercentTop: UILabel!
    @IBOutlet weak var topSlider: UISlider!
    @IBOutlet weak var currentTop: UILabel!
    @IBOutlet weak var willNotifyTop: UILabel!
    
    @IBOutlet weak var changeByBottom: UILabel!
    @IBOutlet weak var changePercentBottom: UILabel!
    @IBOutlet weak var bottomSlider: UISlider!
    @IBOutlet weak var currentBottom: UILabel!
    @IBOutlet weak var willNotifyBottom: UILabel!
    
    @IBAction func saveTouched(_ sender: Any) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Constants.Colors.viewBackgroundColor
        
        switch irNotificationType {
        case .asset:
            navigationItem.title = "Asset Notification"
        case .deposit:
            navigationItem.title = "Deposit Notification"
            hideBottom()
        case .loan:
            navigationItem.title = "Loan Notification"
            hideBottom()
            changeByTop.text = "Notify if Borrow APY changes by"
            currentTop.text = "Current Borrow APY: 2.20%"
        }
        
        let font = UIFont(name: "Akkurat-Bold", size: 18)
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font!,
            .foregroundColor: Constants.Colors.viewBackgroundColor
        ]
        saveButton.setAttributedTitle(NSAttributedString(string: "Save", attributes: attributes), for: .normal)
        
    }
    
    func hideBottom() {
        changeByBottom.isHidden = true
        changePercentBottom.isHidden = true
        bottomSlider.isHidden = true
        currentBottom.isHidden = true
        willNotifyBottom.isHidden = true
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
