//
//  SearchTableViewCell.swift
//  Yacht
//
//  Created by Henry Minden on 9/6/22.
//

import UIKit

class SearchTableViewCell: UITableViewCell {
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
