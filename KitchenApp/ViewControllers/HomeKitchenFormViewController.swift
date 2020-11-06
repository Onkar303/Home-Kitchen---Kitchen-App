//
//  HomeKitchenFormViewController.swift
//  KitchenApp
//
//  Created by Techlocker on 6/11/20.
//

import UIKit
import FirebaseFirestore

class HomeKitchenFormViewController: UIViewController {

    static let STORYBOARD_IDENTIFIER = "HomeKitchenFormViewController"
    
    @IBOutlet weak var kitchenNameTextField: UITextField!
    @IBOutlet weak var KitchenAddressTextField: UITextField!
    @IBOutlet weak var kitchenOwnerTextField: UITextField!
    @IBOutlet weak var kitchenContactNumberTextField: UITextField!
    @IBOutlet weak var foodHandlingCertificateTextField: UITextField!
    @IBOutlet weak var foodHygineCertificateTextField: UITextField!
    
    var userMD5UniqueHash:String?
    var fireStore:Firestore?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureFireBase()
        // Do any additional setup after loading the view.
    }
    
    //MARK:- Handling tapped signup button
    @IBAction func createKitchenTapped(_ sender: Any) {
        setData()
    }
    
    
    //MARK:- Configuring FireStore
    func configureFireBase(){
        fireStore = Firestore.firestore()
    }
    
    
    //MARK:- Send data to FireStore
    func setData(){
        guard let hash = userMD5UniqueHash,!hash.isEmpty else {return }
        let docReference = fireStore?.collection(Constants.FIRE_STORE_HOME_KITCHEN_COLLECTION_NAME).document(hash)
        if isFormFilled() {
            docReference?.setData(createFireStoreDict(), completion: { (error) in
                if let error = error {
                    print("error in sending data to the firebase \(error)")
                } else {
                    self.segueToHomeContoller()
                }
            })
        } else {
            present(Utilities.showMessage(title: "Alert!", message: "Please enter the entire form to proceed!"), animated: true, completion: nil)
        }
    }
    
    //MARK:- Creating OrderCollection and DishCollection New Collection
//    func createNewCollection(){
//        let docReference = fireStore?.collection()
//    }
//    
    
    //MARK:- Validating if Form is filled
    func isFormFilled() -> Bool{
        guard let kitchenName = kitchenNameTextField.text, !kitchenName.isEmpty else {return false}
        guard let kitchenAddress = KitchenAddressTextField.text, !kitchenAddress.isEmpty else {return false}
        guard let kitchenOwner = kitchenOwnerTextField.text, !kitchenOwner.isEmpty else {return false}
        guard let kitcheContactNumber = kitchenContactNumberTextField.text , !kitcheContactNumber.isEmpty else {return false}
        guard let foodHandlingCertificate = foodHandlingCertificateTextField.text , !foodHandlingCertificate.isEmpty else {return false}
        guard let foodAndHyginerCertificate = foodHygineCertificateTextField.text, !foodAndHyginerCertificate.isEmpty else {return false}
        return true
    }
    
    
    //MARK:-- create dictionary for FireStore
    func createFireStoreDict() -> [String:Any]{
        let newHomeKitchen = HomeKitchen()
        newHomeKitchen.kitchenId = userMD5UniqueHash
        newHomeKitchen.kitchenName = kitchenNameTextField.text
        newHomeKitchen.kitchenOwner = kitchenOwnerTextField.text
        newHomeKitchen.kitchenAddress = KitchenAddressTextField.text
        newHomeKitchen.kitchenContactNumber = kitchenContactNumberTextField.text
        
        let newUser = User(userName:UserDefaults.standard.string(forKey: Constants.USERDEFAULTS_USERNAME) , password:UserDefaults.standard.string(forKey: Constants.USERDEFAULTS_PASSOWRD))
        
        newHomeKitchen.userCredentials = newUser
        
        newHomeKitchen.kitchenDishesCollectionReference = Utilities.MD5(string:kitchenNameTextField.text! + String(Utilities.currentTimeInSeconds()))
        newHomeKitchen.kitchenOrdersCollectionReference = Utilities.MD5(string:newUser.userName! + newUser.password! + userMD5UniqueHash!)
        return newHomeKitchen.convertToDictionary()
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


//MARK:- Handling the keyboard
extension HomeKitchenFormViewController:UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        kitchenNameTextField.resignFirstResponder()
        KitchenAddressTextField.resignFirstResponder()
        kitchenOwnerTextField.resignFirstResponder()
        kitchenContactNumberTextField.resignFirstResponder()
        foodHandlingCertificateTextField.resignFirstResponder()
        foodHygineCertificateTextField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}
