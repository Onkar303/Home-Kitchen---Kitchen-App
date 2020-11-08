//
//  ViewController.swift
//  KitchenApp
//
//  Created by Techlocker on 18/10/20.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class LoginViewController: UIViewController {
    @IBOutlet weak var signUpLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var authController:Auth?
    var fireStore:Firestore?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureUI()
        configureAuth()
        configureFireStore()
        attachDelegates()
    }
    
    //MARK:- Configure Auth
    func configureUI(){
        self.navigationController?.navigationBar.isHidden = true
        self.passwordTextField.isSecureTextEntry = true
        attachTapGesture()
    }
    
    //MARK:- Configuring FireBase Auth
    func configureAuth(){
        authController = Auth.auth()
    }
    
    func configureFireStore(){
        fireStore = Firestore.firestore()
    }
    
    //MARK:- Attach Tap gesture
    func attachTapGesture(){
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(segueToSignUpController))
        signUpLabel.addGestureRecognizer(tapGesture)
        signUpLabel.isUserInteractionEnabled = true
    }
    
    //MARK:- Attaching Delegates
    func attachDelegates(){
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    
    
    //MARK:-Segue to SignUpController
    @objc func segueToSignUpController(){
        let storyBoard = UIStoryboard(name:"SignUpStoryboard", bundle: .main)
        let signUpController = storyBoard.instantiateViewController(identifier: "SignUpViewController") as! SignUpViewController
        self.navigationController?.pushViewController(signUpController, animated: true)
    }
    
    
    //MARK:- SignIn Using FireBase
    func signInWithFireBase(){
        
        view.endEditing(true)
        guard let email = emailTextField.text else {return}
        guard let password = passwordTextField.text else {return}
        
        authController?.signIn(withEmail:email, password: password, completion: { (authDataResult, error) in
            if let error = error {
                print("Error occured while signing in  \(error)")
            }else {
                self.getHomeKitchenDocument()
                //Utilities.setUserDefaults(homeKitchen: <#T##HomeKitchen?#>)
                self.segueToHomeController()
                print("Login Successfull")
            }
        })
    }
    
    
    @IBAction func tapLoginButton(_ sender: Any) {
        signInWithFireBase()
    }
    
    
    //MARK:- Segue To HomeController
    func segueToHomeController(){
        self.navigationController?.popViewController(animated: false)
        let storyBoard = UIStoryboard(name: "Main", bundle: .main)
        let tabBarController = storyBoard.instantiateViewController(withIdentifier: "tabBarController")
        self.navigationController?.pushViewController(tabBarController, animated: true)
    }
    
    
    //MARK:- Receiving login data from firestore
    func getHomeKitchenDocument()
    {
        
        let hash = Utilities.MD5(string:emailTextField.text!+passwordTextField.text!)
        let docReference = fireStore?.collection(Constants.FIRE_STORE_HOME_KITCHEN_COLLECTION_NAME).document(hash)
        	
        docReference?.getDocument(completion: { (docSnapShot, error) in
            if let error = error {
                print("error retriving data from the Database \(error)")
            }else {
                let loginDictionary = docSnapShot?.data()
                Utilities.setUserDefaults(homeKitchenDictionary: loginDictionary)
                print(UserDefaults.standard.string(forKey: Constants.USERDEFAULTS_KITCHENDISHESCOLLECTIONREFERENCE))
            }
        })
    }
    
    

    
}

//MARK:- Handling Keyboard
extension LoginViewController:UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        return true
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}

