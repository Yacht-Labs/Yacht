//
//  LedgerAddressSelectTableViewCell.swift
//  Yacht
//
//  Created by Henry Minden on 10/10/22.
//

import UIKit

class LedgerAddressSelectTableViewCell: UITableViewCell {
    @IBOutlet weak var accountName: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var check: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
