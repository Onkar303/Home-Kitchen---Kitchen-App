//
//  Constants.swift
//  KitchenApp
//
//  Created by Techlocker on 23/10/20.
//

import Foundation


class Constants{
    
    static let CORNER_RADIUS = 20
    
    
    static func setUserDefaults(email:String?, password:String?){
        
        guard let email = email else {return}
        guard let password = password else {return}
        
        let userDefaults = UserDefaults.standard
        userDefaults.setValue(email, forKey: "email")
        userDefaults.setValue(password, forKey: "password")
        
        
        
    }
    
}
