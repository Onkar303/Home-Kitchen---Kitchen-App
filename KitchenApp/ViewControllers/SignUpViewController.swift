//
//  SignUpViewController.swift
//  KitchenApp
//
//  Created by Techlocker on 23/10/20.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import CryptoKit

class SignUpViewController: UIViewController {
    
    var authController:Auth!
    var fireStore:Firestore!
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        configureUI()
        configureFirebase()
        attachDelegate()
        
    }
    
    
    
    //MARK:-Configure FireBase Auth
    func configureFirebase(){
        authController = Auth.auth()
        fireStore = Firestore.firestore()
        
        
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
                let hash = self.createDocumentForKitchen()
                self.segueToHomeKitchenViewConntroller(userHash: hash)
            }
        })
        
    }
    
    
    //MARK:- Segue to HomeKitchenFormViewController
    func segueToHomeKitchenViewConntroller(userHash:String?){
        
        guard let userHash = userHash else {return}
        
        let storyboard = UIStoryboard(name:"HomeKitchenFormStoryboard", bundle:.main)
        let homeKitchenFormViewController = storyboard.instantiateViewController(withIdentifier:HomeKitchenFormViewController.STORYBOARD_IDENTIFIER) as! HomeKitchenFormViewController
        
        homeKitchenFormViewController.kitchenId = userHash
        self.navigationController?.pushViewController(homeKitchenFormViewController, animated: true)
    }
    
  
    
    //MARK:- Create New Document for Kitchen
    func createDocumentForKitchen() -> String{
        let user = User.init(userName: UserDefaults.standard.string(forKey:"email"), password: UserDefaults.standard.string(forKey: "password"))
        let hash = Utilities.MD5(string:user.userName! + user.password!)
        print(hash)
        let docReference =  fireStore.collection(Constants.FIRE_STORE_HOME_KITCHEN_COLLECTION_NAME).document("/\(hash)")
        
        docReference.setData(["isCreated" : "true"]) { (error) in
            if let error = error {
                print("Error Creating document in Signup Page with error \(error)")
            }
        }
        
        return hash
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



