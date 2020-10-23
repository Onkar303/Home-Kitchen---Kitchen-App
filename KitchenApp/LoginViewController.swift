//
//  ViewController.swift
//  KitchenApp
//
//  Created by Techlocker on 18/10/20.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    @IBOutlet weak var signUpLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var authController:Auth?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureUI()
        configureAuth()
    }
    
    func configureUI(){
        self.navigationController?.navigationBar.isHidden = true
        self.passwordTextField.isSecureTextEntry = true
        attachTapGesture()
    }
    
    func configureAuth(){
        authController = Auth.auth()
    }
    
    //MARK:- Attach Tap gesture
    func attachTapGesture(){
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(segueToSignUpController))
        signUpLabel.addGestureRecognizer(tapGesture)
        signUpLabel.isUserInteractionEnabled = true
    }
    
    
    @objc func segueToSignUpController(){
        let storyBoard = UIStoryboard(name:"SignUpStoryboard", bundle: .main)
        let signUpController = storyBoard.instantiateViewController(identifier: "SignUpViewController") as! SignUpViewController
        self.navigationController?.pushViewController(signUpController, animated: true)
    }
    
    
    func signInWithFireBase(){
        
        guard let email = emailTextField.text else {return}
        guard let password = passwordTextField.text else {return}
        
        authController?.signIn(withEmail:email, password: password, completion: { (authDataResult, error) in
            
            if let error = error {
                print("Error occured while signing in  \(error)")
            }else {
                Constants.setUserDefaults(email: email, password: password)
                
                print("Login Successfull")
            }
            
        })
        
        
        
    }
    
    @IBAction func tapLoginButton(_ sender: Any) {
        signInWithFireBase()
        
    }
    
}

