//
//  DishInformation.swift
//  KitchenApp
//
//  Created by Techlocker on 4/11/20.
//

import Foundation


class DishInformation:NSObject,Decodable{
    var id:Int?
    var title:String?
    var servings:Int?
    var image:String? //original name "image"
    var summary:String? //original name "summary"
    var readyInMinutes:Int?
    var healthScore:Int?
    var vegetarian:Bool?
    var vegan:Bool?
    var dairyFree:Bool?
    var veryPopular:Bool?
    var documentID:String?
    
    
    enum Keys:String,CodingKey {
        case id
        case title
        case servings
        case image
        case summary
        case readyInMinutes
        case healthScore
        case vegetarian
        case vegan
        case dairyFree
        case veryPopular
    }
    
    required init(from decoder: Decoder) throws {
        let dishContainer = try decoder.container(keyedBy:Keys.self)

        id = try? dishContainer.decode(Int.self, forKey: .id)
        title = try? dishContainer.decode(String.self, forKey: .title)
        servings = try? dishContainer.decode(Int.self, forKey: .servings)
        image = try? dishContainer.decode(String.self, forKey: .image)
        summary = try? dishContainer.decode(String.self, forKey: .summary)
        readyInMinutes = try? dishContainer.decode(Int.self, forKey: .readyInMinutes)
        healthScore = try? dishContainer.decode(Int.self, forKey: .healthScore)
        vegetarian = try? dishContainer.decode(Bool.self, forKey: .vegetarian)
        vegan = try? dishContainer.decode(Bool.self, forKey: .vegan)
        dairyFree = try? dishContainer.decode(Bool.self, forKey: .dairyFree)
        veryPopular = try? dishContainer.decode(Bool.self, forKey: .veryPopular)

    }
    
    func converToDictionary() -> [String:Any] {
        
        var dictionary = [String:Any]()
        dictionary["id"] = id
        dictionary["title"] = title
        dictionary["servings"] = servings
        dictionary["image"] = image
        dictionary["summary"] = summary
        dictionary["readyInMinutes"] = readyInMinutes
        dictionary["healthScore"] = healthScore
        dictionary["vegetarian"] = vegetarian
        dictionary["vegan"] = vegan
        dictionary["dairyFree"] = dairyFree
        dictionary["veryPolular"] = veryPopular
        
        return dictionary
    }
}









