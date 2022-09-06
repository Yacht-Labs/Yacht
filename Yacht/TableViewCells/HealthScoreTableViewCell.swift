//
//  HealthScoreTableViewCell.swift
//  Yacht
//
//  Created by Henry Minden on 8/25/22.
//

import UIKit

class HealthScoreTableViewCell: UITableViewCell {
    var emptyLabel: UILabel?
    @IBOutlet weak var healthScoreLabel: UILabel!
    @IBOutlet weak var tick: UIView!
    @IBOutlet weak var healthConstraint: NSLayoutConstraint!
    @IBOutlet weak var greenWidth: NSLayoutConstraint!
    @IBOutlet weak var redZone: UIView!
    @IBOutlet weak var blackZone: UIView!
    @IBOutlet weak var greenView: UIView!
    
    var healthScore: Double = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        tick.alpha = 0
        healthScoreLabel.alpha = 0
        redZone.alpha = 0
        blackZone.alpha = 0
        greenView.alpha = 0
        
        emptyLabel = UILabel(frame: CGRect(x: 40, y: 4, width: self.bounds.width - 80, height: self.bounds.height - 8))
        emptyLabel?.text = "Euler health score associated with this address will appear here"
        emptyLabel?.textColor = Constants.Colors.oliveDrab
        emptyLabel?.font = UIFont(name: "Akkurat-LightItalic", size: 14)
        emptyLabel?.numberOfLines = 2
        emptyLabel?.alpha = 0
        if let emptyLabel = emptyLabel {
            addSubview(emptyLabel)
        }
        
    }
    
    func setHealthScore() {

        let totalWidth = Double(redZone.frame.width + blackZone.frame.width)
        let newConstraint = Double(redZone.frame.width) * self.healthScore
        if newConstraint > totalWidth {
            healthConstraint.constant = CGFloat(totalWidth)
        } else {
            healthConstraint.constant = CGFloat(newConstraint)
        }
        
        if newConstraint > redZone.frame.width {
            greenWidth.constant = newConstraint - redZone.frame.width
            greenView.alpha = 1
            tick.backgroundColor = .systemGreen
        } else {
            tick.backgroundColor = Constants.Colors.mediumRed
        }
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        
        healthScoreLabel.text = formatter.string(from: NSNumber(value: self.healthScore))
        
        //tick.alpha = 1
        self.healthScoreLabel.alpha = 1
        redZone.alpha = 1
        blackZone.alpha = 1
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
