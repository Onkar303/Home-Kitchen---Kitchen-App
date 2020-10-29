//
//  NewDishTableViewCell.swift
//  KitchenApp
//
//  Created by Techlocker on 30/10/20.
//

import UIKit

class NewDishTableViewCell: UITableViewCell {
    
    static let CELL_IDENTIFIER = "cellNewDish"
    
    @IBOutlet weak var dishImageView: UIImageView!
    @IBOutlet weak var dishNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
