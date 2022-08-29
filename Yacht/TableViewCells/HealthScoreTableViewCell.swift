//
//  HealthScoreTableViewCell.swift
//  Yacht
//
//  Created by Henry Minden on 8/25/22.
//

import UIKit

class HealthScoreTableViewCell: UITableViewCell {
    @IBOutlet weak var healthScoreLabel: UILabel!
    @IBOutlet weak var tick: UIView!
    @IBOutlet weak var healthConstraint: NSLayoutConstraint!
    @IBOutlet weak var redZone: UIView!
    @IBOutlet weak var blackZone: UIView!
    
    var healthScore: Double = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        tick.alpha = 0
        healthScoreLabel.alpha = 0
        
    }
    
    func setHealthScore() {

        let totalWidth = Double(redZone.frame.width + blackZone.frame.width)
        let newConstraint = Double(redZone.frame.width) * self.healthScore
        if newConstraint > totalWidth {
            healthConstraint.constant = CGFloat(totalWidth)
        } else {
            healthConstraint.constant = CGFloat(newConstraint)
        }
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        
        healthScoreLabel.text = formatter.string(from: NSNumber(value: self.healthScore))
        
        tick.alpha = 1
        self.healthScoreLabel.alpha = 1
         
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
