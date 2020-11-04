//
//  DishInformation.swift
//  KitchenApp
//
//  Created by Techlocker on 4/11/20.
//

import Foundation


class DishInformation:NSObject,Decodable{
    var dishId:Int?
    var dishTitle:String?
    var servings:Int?
    var dishImage:String? //original name "image"
    var dishSummary:String? //original name "summary"
    var readyInMinutes:Int?
    var healthScore:Int?
    var vegetarian:Bool?
    var vegan:Bool?
    var dairyFree:Bool?
    var veryPopular:Bool?
    
    
    enum Keys:String,CodingKey {
        case dishId = "id"
        case dishTitle = "title"
        case servings
        case dishImage = "image"
        case dishSummary = "summary"
        case readyInMinutes
        case healthScore
        case vegetarian
        case vegan
        case dairyFree
        case veryPopular
    }
    
    required init(from decoder: Decoder) throws {
        let dishContainer = try decoder.container(keyedBy:Keys.self)
        
        dishId = try? dishContainer.decode(Int.self, forKey: .dishId)
        dishTitle = try? dishContainer.decode(String.self, forKey: .dishTitle)
        servings = try? dishContainer.decode(Int.self, forKey: .servings)
        dishImage = try? dishContainer.decode(String.self, forKey: .dishImage)
        dishSummary = try? dishContainer.decode(String.self, forKey: .dishSummary)
        readyInMinutes = try? dishContainer.decode(Int.self, forKey: .readyInMinutes)
        healthScore = try? dishContainer.decode(Int.self, forKey: .healthScore)
        vegetarian = try? dishContainer.decode(Bool.self, forKey: .vegetarian)
        vegan = try? dishContainer.decode(Bool.self, forKey: .vegan)
        dairyFree = try? dishContainer.decode(Bool.self, forKey: .dairyFree)
        veryPopular = try? dishContainer.decode(Bool.self, forKey: .veryPopular)
        
    }
    
    
    func converToDictionary() -> [String:Any] {
        
        var dictionary = [String:Any]()
        dictionary["dishId"] = dishId
        dictionary["dishTitle"] = dishTitle
        dictionary["servings"] = servings
        dictionary["dishImage"] = dishImage
        dictionary["dishSummary"] = dishSummary
        dictionary["readyInMinutes"] = readyInMinutes
        dictionary["healthScore"] = healthScore
        dictionary["vegetarian"] = vegetarian
        dictionary["vegan"] = vegan
        dictionary["dairyFree"] = dairyFree
        dictionary["veryPolular"] = veryPopular
        
        return dictionary
    }
}









