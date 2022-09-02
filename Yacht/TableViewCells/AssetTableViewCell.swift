//
//  AssetTableViewCell.swift
//  Yacht
//
//  Created by Henry Minden on 8/25/22.
//

import UIKit

class AssetTableViewCell: UITableViewCell {
    @IBOutlet weak var tokenImage: UIImageView!
    @IBOutlet weak var symbol: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var balance: UILabel!
    @IBOutlet weak var lendAPY: UILabel!
    @IBOutlet weak var borrowAPY: UILabel!
    @IBOutlet weak var price: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 6, left: 10, bottom: 6, right: 10))
        contentView.layer.cornerRadius = 20
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = Constants.Colors.mediumRed.cgColor
        contentView.clipsToBounds = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
