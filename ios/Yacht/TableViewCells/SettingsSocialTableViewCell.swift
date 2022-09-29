//
//  SettingsSocialTableViewCell.swift
//  Yacht
//
//  Created by Henry Minden on 9/27/22.
//

import UIKit

class SettingsSocialTableViewCell: UITableViewCell {
    @IBOutlet weak var socialNetwork: UILabel!
    @IBOutlet weak var socialImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
