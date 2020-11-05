//
//  Utilities.swift
//  KitchenApp
//
//  Created by Techlocker on 30/10/20.
//

import Foundation
import UIKit
import CryptoKit

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
    
    
    static func removeHtmlTags(text:String?) ->String{
        guard let text = text else {return ""}
        return text.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }
    
    //MARK:- Setting unique ID Home Kitchen
    static func createHashWithCredentials() -> Int{
        let user =  User.init(userName: UserDefaults.standard.string(forKey:"email"), password: UserDefaults.standard.string(forKey: "password"))
        var hasher = Hasher()
        hasher.combine(user)
        let hasValue = hasher.finalize()
        return hasValue
    }
    
    
    //MARK:- Removing UserDefaults 
    static func removeUserDefaults(){
        let userDefaults = UserDefaults.standard
        userDefaults.removeObject(forKey: Constants.USERDEFAULTS_USERNAME)
        userDefaults.removeObject(forKey: Constants.USERDEFAULTS_PASSOWRD)
    }
    
    //MARK:- Retrived from URL:- https://stackoverflow.com/questions/32163848/how-can-i-convert-a-string-to-an-md5-hash-in-ios-using-swift
    static func MD5(string: String) -> String {
        
        
        let digest = Insecure.MD5.hash(data: string.data(using: .utf8) ?? Data())
        
        return digest.map {
                String(format: "%02hhx", $0)
        }.joined()
    }

}
