//
//  EulerDepositCollectionViewCell.swift
//  Yacht
//
//  Created by Henry Minden on 8/25/22.
//

import UIKit

class EulerDepositCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var tokenImage: UIImageView!
    @IBOutlet weak var tokenName: UILabel!
    @IBOutlet weak var amountDeposited: UILabel!
    @IBOutlet weak var amountDepositedDollars: UILabel!
    @IBOutlet weak var riskAdjustedValue: UILabel!
    @IBOutlet weak var riskAdjustedValueDollars: UILabel!
    @IBOutlet weak var lendAPY: UILabel!
    @IBOutlet weak var collateralFactor: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        tokenImage.layer.cornerRadius = tokenImage.frame.height / 2
        tokenImage.clipsToBounds = true
        
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        contentView.layer.cornerRadius = 18
        contentView.backgroundColor = Constants.Colors.parchment
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = Constants.Colors.lightGray.cgColor
        contentView.clipsToBounds = true
    }
}
