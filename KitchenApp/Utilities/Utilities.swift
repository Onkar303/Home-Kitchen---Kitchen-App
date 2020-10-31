//
//  Utilities.swift
//  KitchenApp
//
//  Created by Techlocker on 30/10/20.
//

import Foundation
import UIKit

class Utilities {
    
    static func setUserDefaults(email:String?, password:String?){
        
        guard let email = email else {return}
        guard let password = password else {return}
        
        let userDefaults = UserDefaults.standard
        userDefaults.setValue(email, forKey: "email")
        userDefaults.setValue(password, forKey: "password")
    }
    
    static func showMessage(title:String? ,message:String?) -> UIAlertController{
    
        guard let title = title else {return UIAlertController()}
        guard let message = message else {return UIAlertController()}
        
        let alertcontroller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title:"Ok", style: .cancel, handler: nil)
        
        alertcontroller.addAction(alertAction)
        return alertcontroller
        
    }
    
    
    static func getImage(url:String?,imageView:UIImageView){
        guard let stringUrl = url else {return}
        let url = URL(string:stringUrl)
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if error != nil{
                print("error fetching imgaes")
            }
            DispatchQueue.main.async {
                imageView.image = UIImage(data: data!)
            }
        }.resume()
    }
}
