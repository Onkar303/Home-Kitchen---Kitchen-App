//
//  SignUpViewController.swift
//  KitchenApp
//
//  Created by Techlocker on 23/10/20.
//

import UIKit
import FirebaseAuth

class SignUpViewController: UIViewController {
    
    var authController:Auth?
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        configureUI()
        configureAuth()
        attachDelegate()
    }
    
    
    
    //MARK:-Configure FireBase Auth
    func configureAuth(){
        authController = Auth.auth()
    }
    
    
    //MARK:-Configure UI
    func configureUI(){
        passwordTextField.isSecureTextEntry = true
    }
    
    
    @IBAction func signUpTapped(_ sender: Any) {
        signInWithIdAndPAssword()
    }
    
    
    //MARK:- AttachDelegate
    func attachDelegate(){
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    
    //MARK:- SignIn With FireBase
    func signInWithIdAndPAssword(){
        
        guard let email = emailTextField.text else {return}
        guard let password = passwordTextField.text else {return}
        
        
        authController?.createUser(withEmail: email, password:password, completion: { (authDataResult, error) in
            if let error = error {
                print("error in signin in \(error)")
            }else{
                Utilities.setUserDefaults(email: email, password: password)
                self.segueToHomeContoller()
            }
        })
        
    }
    
    
    //MARK:- Segue to Home Controller
    func segueToHomeContoller(){
        let storyboard = UIStoryboard(name:"Main", bundle:.main)
        let tabBarController = storyboard.instantiateViewController(withIdentifier:"tabBarController")
        self.navigationController?.pushViewController(tabBarController, animated: true)
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

//MARK:- Handling Keyboard
extension SignUpViewController:UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        return true
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}



