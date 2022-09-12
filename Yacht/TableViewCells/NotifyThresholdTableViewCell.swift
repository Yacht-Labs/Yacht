//
//  NotifyThresholdTableViewCell.swift
//  Yacht
//
//  Created by Henry Minden on 8/30/22.
//

import UIKit

protocol NotifyThresholdTableViewCellDelegate: AnyObject {
    func sliderValueChanged(type: NotifyThresholdType, value: Int)
}
enum NotifyThresholdType {
    case supplyUpper
    case supplyLower
    case borrowUpper
    case borrowLower
}

class NotifyThresholdTableViewCell: UITableViewCell {
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var thresholdLabel: UILabel!
    @IBOutlet weak var changesByText: UILabel!
    @IBOutlet weak var willNotify: UILabel!
    @IBOutlet weak var activateButton: UIButton!
    var isActive: Bool = true
    weak var delegate: NotifyThresholdTableViewCellDelegate?
    
    @IBAction func activateTouched(_ sender: Any) {
        setActive(isActive: !isActive)
    }
    
    
    var type: NotifyThresholdType? {
        didSet {
            self.delegate?.sliderValueChanged(type: type!, value: Int(slider.value * 100) )
            
            if !isActive {
                willNotify.text = "Touch activate to set this notification"
            } else {
                setWillNotify(value: slider.value)
            }
            
            thresholdLabel.text = numberFormatter.string(from: NSNumber(value: slider.value))
            
            switch type {
            case .supplyLower:
                changesByText.text = "Notify if Supply APY falls by:"
            case .supplyUpper:
                changesByText.text = "Notify if Supply APY rises by:"
            case .borrowLower:
                changesByText.text = "Notify if Borrow APY falls by:"
            case .borrowUpper:
                changesByText.text = "Notify if Borrow APY rises by:"
            case .none:
                changesByText.text = "??"
            }
        }
    }
    
    var apy: Float?
    
    var value: Int? {
        didSet {
            if value == 0 {
                setActive(isActive: false)
            } else {
                slider.setValue((Float(value ?? 0) / 100), animated: true)
                setWillNotify(value: slider.value)
                thresholdLabel.text = numberFormatter.string(from: NSNumber(value: slider.value))
            }
         
        }
    }
    
    let numberFormatter: NumberFormatter = NumberFormatter()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        numberFormatter.numberStyle = .percent
        numberFormatter.maximumFractionDigits = 0
        
        slider.addTarget(self, action: #selector(onSlide), for: UIControl.Event.valueChanged)
    }
    
    @objc
    func onSlide() {
        numberFormatter.maximumFractionDigits = 0
        thresholdLabel.text = numberFormatter.string(from: NSNumber(value: slider.value))
        if let type = type {
            self.delegate?.sliderValueChanged(type: type, value: Int(slider.value * 100))
            setWillNotify(value: slider.value)
        }
    }
                                                                                   
    func setWillNotify(value: Float) {
        guard let apy = self.apy else {
            return
        }
        numberFormatter.maximumFractionDigits = 2
        switch type {
        case .supplyLower:
            willNotify.text = "Will notify if Supply APY goes below " + numberFormatter.string(from: NSNumber(value: ((1 - value) * (apy / 100))))!
            return
        case .borrowLower:
            willNotify.text = "Will notify if Borrow APY goes below " + numberFormatter.string(from: NSNumber(value: ((1 - value) * (apy / 100))))!
            return
        case .supplyUpper:
            willNotify.text = "Will notify if Supply APY goes above " + numberFormatter.string(from: NSNumber(value: ((1 + value) * (apy / 100))))!
            return
        case .borrowUpper:
            willNotify.text = "Will notify if Borrow APY goes above " + numberFormatter.string(from: NSNumber(value: ((1 + value) * (apy / 100))))!
            return
        case .none:
            return
        }
    }

    func setActive(isActive: Bool) {
        if isActive {
            if self.value == 0 {
                self.value = 20
            }
            
            thresholdLabel.alpha = 1
            slider.alpha = 1
            slider.isEnabled = true
            slider.setValue((Float(value ?? 0) / 100), animated: true)
            setWillNotify(value: slider.value)
            
            let font = UIFont(name: "Akkurat-Bold", size: 12)
            let attributes: [NSAttributedString.Key: Any] = [
                .font: font!,
                .foregroundColor: Constants.Colors.mediumRed
            ]
            self.activateButton.setAttributedTitle(NSAttributedString(string: "Deactivate", attributes: attributes), for: .normal)
            
            self.delegate?.sliderValueChanged(type: type!, value: Int(slider.value * 100))
            
            
            switch type {
            case .supplyLower:
                changesByText.text = "Notify if Supply APY falls by:"
            case .supplyUpper:
                changesByText.text = "Notify if Supply APY rises by:"
            case .borrowLower:
                changesByText.text = "Notify if Borrow APY falls by:"
            case .borrowUpper:
                changesByText.text = "Notify if Borrow APY rises by:"
            case .none:
                changesByText.text = "??"
            }
            
            self.isActive = true
        } else {
            thresholdLabel.alpha = 0
            slider.alpha = 0
            slider.isEnabled = false
            willNotify.text = "Touch activate to set this notification"
            
            let font = UIFont(name: "Akkurat-Bold", size: 12)
            let attributes: [NSAttributedString.Key: Any] = [
                .font: font!,
                .foregroundColor: Constants.Colors.mediumRed
            ]
            self.activateButton.setAttributedTitle(NSAttributedString(string: "Activate", attributes: attributes), for: .normal)
            
            self.delegate?.sliderValueChanged(type: type!, value: 0)
            
            switch type {
            case .supplyLower:
                changesByText.text = "Low Supply APY Notification Off"
            case .supplyUpper:
                changesByText.text = "High Supply APY Notification Off"
            case .borrowLower:
                changesByText.text = "Low Borrow APY Notification Off"
            case .borrowUpper:
                changesByText.text = "High Supply APY Notification Off"
            case .none:
                changesByText.text = "??"
            }
            
            self.isActive = false
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
