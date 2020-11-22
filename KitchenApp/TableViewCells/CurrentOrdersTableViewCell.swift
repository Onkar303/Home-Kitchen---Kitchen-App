//
//  CurrentOrdersTableViewCell.swift
//  KitchenApp
//
//  Created by Techlocker on 22/11/20.
//

import Foundation
import UIKit

class CurrentOrdersTableViewCell:UITableViewCell{
    static let CELL_IDENTIFIER = "currentOrderCell"
    @IBOutlet weak var numberOfDishes: UILabel!
    @IBOutlet weak var orderNumber: UILabel!
    @IBOutlet weak var customerName: UILabel!
    @IBOutlet weak var customerPhoneNumber: UILabel!
    
}
