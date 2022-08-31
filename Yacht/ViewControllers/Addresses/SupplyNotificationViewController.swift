//
//  SupplyNotificationViewController.swift
//  Yacht
//
//  Created by Henry Minden on 8/30/22.
//

import UIKit

class SupplyNotificationViewController: UIViewController {
    var lendAPY: Double = 0
    var symbolValue: String = ""
    let numberFormatter: NumberFormatter = NumberFormatter()
    
    @IBOutlet weak var yachtImage: UIImageView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var symbol: UILabel!
    @IBOutlet weak var slider: UISlider!
    
    @IBOutlet weak var changeBy: UILabel!
    @IBOutlet weak var currentLendAPY: UILabel!
    @IBOutlet weak var willNotify: UILabel!
    
    @IBAction func saveTouched(_ sender: Any) {
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Deposit Notification"
        symbol.text = symbolValue
        
        let font = UIFont(name: "Akkurat-Bold", size: 18)
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font!,
            .foregroundColor: Constants.Colors.viewBackgroundColor
        ]
        saveButton.setAttributedTitle(NSAttributedString(string: "Save", attributes: attributes), for: .normal)
        
        //let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .percent
        numberFormatter.maximumFractionDigits = 0
        
        changeBy.text = numberFormatter.string(from: NSNumber(value: slider.value))
        slider.addTarget(self, action: #selector(onSlide), for: UIControl.Event.valueChanged)
        numberFormatter.maximumFractionDigits = 2
        let currentAPY = Float(lendAPY) / 100
        let upperbound = currentAPY * (1 + slider.value)
        let lowerbound = currentAPY * (1 - slider.value)
        currentLendAPY.text = "Current Lend APY: " + (numberFormatter.string(from: NSNumber(value: currentAPY)) ?? "0")
        willNotify.text = "Will notify below " +
            (numberFormatter.string(from: NSNumber(value: lowerbound)) ?? "0") + ", and above " +
            (numberFormatter.string(from: NSNumber(value: upperbound)) ?? "0")
    }
    
    @objc
    func onSlide() {
        numberFormatter.maximumFractionDigits = 0
        changeBy.text = numberFormatter.string(from: NSNumber(value: slider.value))
        slider.addTarget(self, action: #selector(onSlide), for: UIControl.Event.valueChanged)
        numberFormatter.maximumFractionDigits = 2
        let currentAPY = Float(lendAPY) / 100
        let upperbound = currentAPY * (1 + slider.value)
        let lowerbound = currentAPY * (1 - slider.value)
        willNotify.text = "Will notify below " +
            (numberFormatter.string(from: NSNumber(value: lowerbound)) ?? "0") + ", and above " +
            (numberFormatter.string(from: NSNumber(value: upperbound)) ?? "0")
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
