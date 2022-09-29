//
//  EulerLoanCollectionViewCell.swift
//  Yacht
//
//  Created by Henry Minden on 8/25/22.
//

import UIKit

class EulerLoanCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var tokenImage: UIImageView!
    @IBOutlet weak var tokenName: UILabel!
    @IBOutlet weak var amountOwed: UILabel!
    @IBOutlet weak var amountOwedDollars: UILabel!
    @IBOutlet weak var borrowAPY: UILabel!
    @IBOutlet weak var eulAPY: UILabel!
    
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
