//
//  OrderDishesDetailTableViewCell.swift
//  KitchenApp
//
//  Created by Techlocker on 22/11/20.
//

import Foundation
import UIKit

class OrderDishesDetailTableViewCell:UITableViewCell {
    
    static let CELL_IDENTIFIER = "cellDetailsCell"
    
    @IBOutlet weak var dishName: UILabel!
    @IBOutlet weak var dishQuantity: UILabel!
}
