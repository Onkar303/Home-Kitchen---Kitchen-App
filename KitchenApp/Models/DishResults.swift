//
//  Dishes.swift
//  KitchenApp
//
//  Created by Techlocker on 30/10/20.
//

import Foundation

class DishResults:NSObject,Decodable{
    var results:[Dishes]?
    
    enum CodingKeys:String,CodingKey{
        case results
    }
}

class Dishes:NSObject,Decodable{
    var id:Int?
    var title:String?
    var image:String?
    var imageType:String?
    
        
    enum CodinKeys:String,CodingKey{
        case id
        case title
        case image
        case imageType
    }

}


