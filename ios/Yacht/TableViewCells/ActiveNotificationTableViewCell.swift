//
//  ActiveNotificationTableViewCell.swift
//  Yacht
//
//  Created by Henry Minden on 8/31/22.
//

import UIKit

class ActiveNotificationTableViewCell: UITableViewCell {
    @IBOutlet weak var notificationType: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
