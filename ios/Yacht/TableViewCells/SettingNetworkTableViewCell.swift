//
//  SettingNetworkTableViewCell.swift
//  Yacht
//
//  Created by Henry Minden on 8/26/22.
//

import UIKit

class SettingNetworkTableViewCell: UITableViewCell {
    @IBOutlet weak var network: UILabel!
    @IBOutlet weak var type: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
