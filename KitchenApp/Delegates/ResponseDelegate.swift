//
//  ResponseDelegate.swift
//  KitchenApp
//
//  Created by Techlocker on 10/11/20.
//

import Foundation

protocol ResponseDelegate:AnyObject {
    
    func onUpdateResponse(status:Bool,updateField:String?)
    
}
