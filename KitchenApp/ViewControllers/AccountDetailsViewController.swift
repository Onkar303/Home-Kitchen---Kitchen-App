//
//  AccountDetailsViewController.swift
//  KitchenApp
//
//  Created by Techlocker on 23/10/20.
//

import UIKit
import FirebaseAuth

class AccountDetailsViewController: UIViewController {

    var authController:Auth?
    override func viewDidLoad() {
        super.viewDidLoad()
        instantiateAuth()
        signOut()
        // Do any additional setup after loading the view.
    }
    
    
    func instantiateAuth(){
        authController = Auth.auth()
    }
    
    
    func signOut(){
        do {
            try authController?.signOut()
            tabBarController?.removeFromParent()
        } catch let err {
            print("error signinout \(err)")
        }
    }
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
