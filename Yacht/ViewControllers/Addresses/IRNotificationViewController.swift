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
    var lendAPY: Double = 0
    var borrowAPY: Double = 0
    let numberFormatter: NumberFormatter = NumberFormatter()
    
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
        
        //let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .percent
        numberFormatter.maximumFractionDigits = 0
        
        changePercentTop.text = numberFormatter.string(from: NSNumber(value: (topSlider.value / 100)))
        topSlider.addTarget(self, action: #selector(onTopSlide), for: UIControl.Event.valueChanged)
        numberFormatter.maximumFractionDigits = 2
        let currentAPY = Float(lendAPY)
        let upperbound = Float(topSlider.value / 100) * ((currentAPY / 100) + 1)
        let lowerbound = Float(topSlider.value / 100) * (Float(lendAPY) / 100)
        currentTop.text = "Current Lend APY: " + (numberFormatter.string(from: NSNumber(value: currentAPY / 100)) ?? "0")
        willNotifyTop.text = "Will notify below " +
        (numberFormatter.string(from: NSNumber(value: lowerbound)) ?? "0") + ", and above " +
        (numberFormatter.string(from: NSNumber(value: upperbound)) ?? "0")
    }
    
    @objc
    func onTopSlide() {
        numberFormatter.maximumFractionDigits = 0
        changePercentTop.text = numberFormatter.string(from: NSNumber(value: (topSlider.value / 100)))
        numberFormatter.maximumFractionDigits = 2
        let currentAPY = Float(lendAPY)
        let upperbound = Float(topSlider.value / 100) * ((currentAPY / 100) + 1)
        let lowerbound = Float(topSlider.value / 100) * (Float(lendAPY) / 100)
        willNotifyTop.text = "Will notify below " +
        (numberFormatter.string(from: NSNumber(value: lowerbound)) ?? "0") + ", and above " +
        (numberFormatter.string(from: NSNumber(value: upperbound)) ?? "0")
        
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
