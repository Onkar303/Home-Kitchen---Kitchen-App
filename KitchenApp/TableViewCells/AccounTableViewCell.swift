//
//  AccounTableViewCell.swift
//  KitchenApp
//
//  Created by Techlocker on 5/11/20.
//

import UIKit

class AccounTableViewCell: UITableViewCell {
    
    static let CELL_IDENTIFIER = "accountCell"

    @IBOutlet weak var accountDetailsLabel: UILabel!
    @IBOutlet weak var accountDetailsValue: UILabel!
    @IBOutlet weak var accountCellImageView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
