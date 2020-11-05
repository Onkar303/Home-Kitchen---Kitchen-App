//
//  User.swift
//  KitchenApp
//
//  Created by Techlocker on 5/11/20.
//

import Foundation
import UIKit

struct User:Hashable{
    var userName:String?
    var password:String?
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(userName)
        hasher.combine(password)
    }
}

