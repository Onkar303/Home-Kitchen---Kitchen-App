//
//  DishToOrder.swift
//  KitchenApp
//
//  Created by Techlocker on 22/11/20.
//

import Foundation

class DishToOrder:NSObject,Decodable{
    var dishId:Int?
    var dishName:String?
    var dishQuantity:Int?
    var dishPrice:Double?
    
    enum Keys:String,CodingKey {
        case dishId
        case dishName
        case dishQuantity
        case dishPrice
    }
    


}
