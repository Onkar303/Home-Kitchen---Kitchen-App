//
//  AccountTableViewImageCell.swift
//  KitchenApp
//
//  Created by Techlocker on 17/11/20.
//

import UIKit

class AccountTableViewImageCell: UITableViewCell {

    static let CELL_IDENTIFIER = "AccountTableViewImageCell"
    
    @IBOutlet weak var kitchenImageView: UIImageView!
    @IBOutlet weak var kitchenImageViewLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

