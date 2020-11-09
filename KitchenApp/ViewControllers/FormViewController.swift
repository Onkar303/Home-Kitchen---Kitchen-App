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
    var firebaseAuth:Auth?
    var firesStore:Firestore?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        configureFirebase()
        // Do any additional setup after loading the view.
    }
    
    //MARK:- Configuring UI
    func configureUI(){
        paramTitleLabel.text = titleLabel
        commonTextField.transform()
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
        
        if title == "Username" {
            
        }
        
        if title == "Password"{
            
        }
        
        if title == "Kitchen Name"{
            updateHomeKitchen(updateField:Constants.USERDEFAULTS_KITCEHNNAME , text: text)
            UserDefaults.standard.setValue(Constants.USERDEFAULTS_KITCEHNNAME, forKey: text)
        }
        
        if title == "Owner"{
            updateHomeKitchen(updateField:Constants.USERDEFAULTS_KITCHENOWNER , text: text)
            UserDefaults.standard.setValue(Constants.USERDEFAULTS_KITCHENOWNER, forKey: text)
        }
        
        if title == "Address" {
            updateHomeKitchen(updateField:Constants.USERDEFAULTS_KITCHENADDRESS , text: text)
            UserDefaults.standard.setValue(Constants.USERDEFAULTS_KITCHENADDRESS, forKey: text)
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
                self.present(Utilities.showMessage(title: "Success!", message: "Update Successfull"), animated: true, completion: nil)
            }
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
