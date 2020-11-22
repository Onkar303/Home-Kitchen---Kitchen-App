//
//  OrderCustomerDetailsTableViewCell.swift
//  KitchenApp
//
//  Created by Techlocker on 22/11/20.
//

import Foundation
import UIKit


class OrderCustomerDetailsTableViewCell:UITableViewCell {
    
    static let CELL_IDENTIFIER = "customerDetailsCell"
    
    @IBOutlet weak var customerNameLabel: UILabel!
    @IBOutlet weak var customerPhoneNumberLabel: UILabel!
    @IBOutlet weak var customerAddressLabel: UILabel!
}
