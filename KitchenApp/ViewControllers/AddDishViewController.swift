//
//  AddDishesViewController.swift
//  KitchenApp
//
//  Created by Techlocker on 29/10/20.
//

import UIKit
import Firebase
import FirebaseFirestore

class AddDishViewController: UIViewController {

    static let SCREEN_IDENTIFIER = "AddDishViewController"
    
    var documentReference:DocumentReference?
    var fireStore:Firestore?
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configureUI()
        configureFireStore()
        fetchDish()
        
        
    }
    
    
    //MARK:- Cofigure UI
    func configureUI(){
        self.title = "Dish Name"
    }
    
    
    //MARK:- Configuring FireStore Instance
    //Successfully added initial data
    func configureFireStore(){
        fireStore = Firestore.firestore()
    }
    
    //MARK:-Adding New Dish to fireStore
    func setDish(){
        let reference = fireStore?.collection("/Sample").document("/FirstSampleData")
        let dataToSave:[String:Any] = ["name":"aryan","surname":"kalpavriksha"]
        reference?.setData(dataToSave) { (error) in
            if let error = error {
                print("an error occured while saving the data \(error)")
            }
        }
    }
    
    func fetchDish(){
        
        fireStore?.collection("/Sample").document("/FirstSampleData").addSnapshotListener({ (documentL, error) in
            let name = documentL?.data()
            print(name)
        })
    }
    
    
    func addDish(){
        fireStore?.collection("/Sample").addDocument(data: ["name":"onkar","surname":"kalpavriksha"], completion: { (error) in
            if let error = error {
                print("error entering the data \(error)")
            }else{
                print("document added successfully")
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
