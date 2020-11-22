//
//  OrderHistoryTableViewCell.swift
//  KitchenApp
//
//  Created by Techlocker on 22/11/20.
//

import Foundation
import UIKit

class OrderHistoryTableViewCell:UITableViewCell{
    static let CELL_IDENTIFIER = "orderHistoryCell"
    @IBOutlet weak var numberOfDishes: UILabel!
    @IBOutlet weak var customerName: UILabel!
    @IBOutlet weak var customerPhoneNumber: UILabel!
}
