//
//  Order.swift
//  KitchenApp
//
//  Created by Techlocker on 22/11/20.
//

import Foundation

class Order:NSObject,Decodable{
    var customerName:String?
    var customerContactNumber:Int?
    var customerAddress:String?
    var customerId:String?
    var totalAmount:Int?
    var kitchenName:String?
    var kitchenId:String?
    var kitchenOrderReference:String?
    var isOrderCompleted:Bool?
    var orderId:String?
    var dishToOrder:[DishToOrder]?
    
    enum Keys:String,CodingKey {
        case customerName
        case customerContactNumber
        case customerAddress
        case customerId
        case totalAmount
        case kitchenName
        case kitchenId
        case kitchenOrderReference
        case isOrderCompleted
        case dishToOrder
        case orderId
    }
    
    
}
