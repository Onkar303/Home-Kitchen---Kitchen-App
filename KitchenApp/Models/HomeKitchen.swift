//
//  HomeKitchen.swift
//  KitchenApp
//
//  Created by Techlocker on 5/11/20.
//

import Foundation





class HomeKitchen {
    
    var userCredentials:User?
    var kitchenName:String?
    var kitchenAddress:String?
    var kitchenOwner:String?
    var kitchenContactNumber:String?
    var foodHandlingCertificate:String?
    var foodAndHygineCertificate:String?
    var kitchenId:String?
    
    
    func convertToDictionary() -> [String:Any] {
        var dictionary = [String:Any]()
        
        dictionary["email"] = userCredentials?.userName
        dictionary["password"] = userCredentials?.password
        dictionary["kitchenName"] = kitchenName
        dictionary["kitchenAddress"] = kitchenAddress
        dictionary["kitchenOwner"] = kitchenOwner
        dictionary["kitchenContactNumber"] = kitchenContactNumber
        dictionary["foodHandlingCertificate"] = foodHandlingCertificate
        dictionary["foodAndHygineCertificate"] = foodAndHygineCertificate
        dictionary["kitchenID"] = kitchenId
        
        return dictionary
    }
    
}

