//
//  OrderDetailsViewController.swift
//  KitchenApp
//
//  Created by Techlocker on 22/11/20.
//

import Foundation
import UIKit

class OrderDetailsViewController:UIViewController{
    
    static let STORYBOARD_IDENTIFIER = "OrderDetailsViewController"
    let CUSTOMER_SECTION = 0
    let DISHES_SECTION = 1
    
    
    @IBOutlet weak var orderDetailsTableView: UITableView!
 
    var order:Order!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        attachDelegates()
    }
    
    //MARK:- Configure UI
    func configureUI(){
        
    }
    
    
    //MARK:-Attach Delegates
    func attachDelegates(){
        orderDetailsTableView.delegate = self
        orderDetailsTableView.dataSource = self
    }
    
}

extension OrderDetailsViewController:UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == CUSTOMER_SECTION {
            return 1
        }
        
        return order.dishToOrder!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == CUSTOMER_SECTION {
            
            let customerCell = tableView.dequeueReusableCell(withIdentifier: OrderCustomerDetailsTableViewCell.CELL_IDENTIFIER,for: indexPath) as! OrderCustomerDetailsTableViewCell
            customerCell.customerNameLabel.text = order?.customerName
            customerCell.customerPhoneNumberLabel.text = String(order?.customerContactNumber ?? 0)
            customerCell.customerAddressLabel.text = order?.customerAddress
            return customerCell
        }
        
        let dishCell = tableView.dequeueReusableCell(withIdentifier: OrderDishesDetailTableViewCell.CELL_IDENTIFIER, for: indexPath) as! OrderDishesDetailTableViewCell
        
        dishCell.dishName.text = order.dishToOrder![indexPath.row].dishName
        dishCell.dishQuantity.text = "\(order.dishToOrder![indexPath.row].dishQuantity! )"
        
        return dishCell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == DISHES_SECTION {
            return "DISHES"
        }
        return "CUSTOMER"
    }
    
    
}
