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
    
    weak var delegate: NotifyThresholdTableViewCellDelegate?
    
    var type: NotifyThresholdType? {
        didSet {
            self.delegate?.sliderValueChanged(type: type!, value: Int(slider.value * 100) )
            setWillNotify(value: slider.value)
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
            slider.setValue((Float(value ?? 0) / 100), animated: true)
            setWillNotify(value: slider.value)
            thresholdLabel.text = numberFormatter.string(from: NSNumber(value: slider.value))
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

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
