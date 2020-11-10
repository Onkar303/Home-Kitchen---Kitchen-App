//
//  FormViewController.swift
//  KitchenApp
//
//  Created by Techlocker on 5/11/20.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class FormViewController: UIViewController {
    
    static let STORYBOARD_IDENTIFIER = "FromViewController"
    @IBOutlet weak var paramTitleLabel: UILabel!
    @IBOutlet weak var commonTextField: CustomTextField!
    
    var titleLabel:String?
    var value:String?
    var firebaseAuth:Auth?
    var firesStore:Firestore?
    var responseDelegate:ResponseDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        configureFirebase()
        // Do any additional setup after loading the view.
    }
    
    //MARK:- Configuring UI
    func configureUI(){
        paramTitleLabel.text = titleLabel
        guard let value = value else {return}
        commonTextField.text = value
        //commonTextField.transform()
        
        if paramTitleLabel.text == Constants.ACCOUNT_PASSWORD_PARAM {
            commonTextField.isSecureTextEntry = true
        }
    }
    
    //MARK:- Configure firebase
    func configureFirebase(){
        firebaseAuth = Auth.auth()
        firesStore = Firestore.firestore()
    }
    
    //MARK:- Handling Save
    @IBAction func saveTapped(_ sender: Any) {
        guard let title = titleLabel , !title.isEmpty else {return}
        guard let text = commonTextField.text , !text.isEmpty else {return}
        
        if title == "Password"{
            changePassword(password: text)
        }else if title == "Kitchen Name"{
            updateHomeKitchen(updateField:Constants.USERDEFAULTS_KITCEHNNAME , text: text)
        }else if title == "Owner"{
            updateHomeKitchen(updateField:Constants.USERDEFAULTS_KITCHENOWNER , text: text)
        }else if title == "Address" {
            updateHomeKitchen(updateField:Constants.USERDEFAULTS_KITCHENADDRESS , text: text)
        } else {
            updateHomeKitchen(updateField:Constants.USERDEFAULTS_KITCHENCONTACTNUMBER , text: text)
        }
    }
    
    
    func changeLoginCredentials(){
        
    }
    
    
    //MARK:- updating HomeKitchen
    func updateHomeKitchen(updateField:String,text:String){
        guard let kitchenId = UserDefaults.standard.string(forKey: Constants.USERDEFAULTS_KITCHENID),!kitchenId.isEmpty else {return}
        let docReference = firesStore?.collection(Constants.FIRE_STORE_HOME_KITCHEN_COLLECTION_NAME).document(kitchenId)
        
        docReference?.updateData([updateField : text], completion: { (error) in
            if let error = error {
                print("error updating data \(error)")
            } else {
                self.dismiss(animated: true, completion: nil)
                self.updateUserInformation { (isUpdated) in
                    if isUpdated{
                        self.responseDelegate?.onUpdateResponse(status: isUpdated,updateField: updateField)
                    }
                }
            }
        })
    }
    
    
    //MARK:-Change userInformation
    func updateUserInformation(completion: @escaping (Bool)->Void){
        guard let homeKitchenId = Utilities.homeKitchenId else {return}
        let docReference = firesStore?.collection(Constants.FIRE_STORE_HOME_KITCHEN_COLLECTION_NAME).document(homeKitchenId)
        
        docReference?.getDocument(completion: { (docSnapShot, error) in
            if let error = error {
                print("error in fecth userDocumnet \(error)")
                return completion(false)
            }
            let kitchenData = docSnapShot?.data()
            Utilities.setUserDefaults(homeKitchenDictionary:docSnapShot?.data())
            return completion(true)
        })
    }
        
    //MARK:- Change the Password
    func changePassword(password:String?){
        guard let password = password else {return}
        firebaseAuth?.currentUser?.updateEmail(to:password, completion: { (error) in
            if let error = error{
                self.present(Utilities.showMessage(title:Constants.ERROR, message: error.localizedDescription), animated: true, completion: nil)
                return
            }            
            self.responseDelegate?.onUpdateResponse(status: true, updateField: "Password")
        })
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
