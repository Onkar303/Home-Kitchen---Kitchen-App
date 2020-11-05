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
    
    @IBOutlet weak var dishSummaryTextField: UILabel!
    @IBOutlet weak var dishImageView: UIImageView!
    
    var documentReference:DocumentReference?
    var fireStore:Firestore?
    var dishId:Int?
    var dishInformation:DishInformation?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        configureUI()
        configureFireStore()
        fetchDish()
        
        
    }
    
    
    //MARK:- Cofigure UI
    func configureUI(){
    
    }
    
    
    //MARK:- Configuring FireStore Instance
    //Successfully added initial data
    func configureFireStore(){
        fireStore = Firestore.firestore()
    }
    
    //MARK:-Adding New Dish to FireStore
    func setDish(){
        let reference = fireStore?.collection("/Sample").document("/FirstSampleData")
        let dataToSave:[String:Any] = ["name":"aryan","surname":"kalpavriksha"]
        reference?.setData(dataToSave) { (error) in
            if let error = error {
                print("an error occured while saving the data \(error)")
            }
        }
        
        
    }
    
    //    func fetchDish(){
    //
    //        fireStore?.collection("/Sample").document("/FirstSampleData").addSnapshotListener({ (documentL, error) in
    //            let name = documentL?.data()
    //            print(name)
    //        })
    //    }
    
    @IBAction func AddDish(_ sender: Any) {
        addDishConfirmation()
    }
    
    //MARK:- Adding Dish to FireBase
    func addDish(){
        guard let dict = dishInformation?.converToDictionary() else {
            print("error sending data")
            return
        }
        fireStore?.collection("/Sample").addDocument(data:dict, completion: { (error) in
            if let error = error {
                print("error entering the data \(error)")
            }else{
                self.present(Utilities.showMessage(title:Constants.SUCCESS, message:"Dish Added Successfully!"), animated: true, completion: nil)
            }
        })
    }
    
    
    //MARK:- Fetch the Dish by Id
    func fetchDish(){
        guard let dishId = dishId else{return}
        let url = Constants.SPOONOCULAR_BASE + "\(dishId)/" + Constants.SPOONOCULAR_INFORMATIONPARAM  + Constants.SPOONOCULAR_KEYPARAM+Constants.SPOONOCULAR_KEY
        
        print(url)
        
        URLSession.shared.dataTask(with: URL(string: url)!) { (data, urlResponse, error) in
            if let error = error {
                print("error iun fetching Dish\(error)")
                return
            }

            guard let data = data else {return}
            do {
                let jsonDecoder = JSONDecoder()
                self.dishInformation = try jsonDecoder.decode(DishInformation.self, from: data)
                DispatchQueue.main.async {
                    self.title = self.dishInformation?.dishTitle
                    self.dishSummaryTextField.text = Utilities.removeHtmlTags(text: self.dishInformation?.dishSummary)
                    Utilities.getImage(url:self.dishInformation?.dishImage, imageView: self.dishImageView)
                }
              
            }catch let error{
                print("error parsing data \(error)")
            }
        }.resume()
    }
    
    
    
    //MARK:- Adding Confirmation Alert Controller
    func addDishConfirmation(){
        guard let dishTitle = dishInformation?.dishTitle else {return}
        let confirmationAlertContoller = UIAlertController(title:"Confirmation", message:"Are you sure you want to add '\(dishTitle)'", preferredStyle: .alert)
        let confirmationAlertActionConfirm = UIAlertAction(title: Constants.CONFIRM, style: .default) { (alertAction) in
            self.addDish()
        }
        let confirmationAlertActionCancel = UIAlertAction(title: Constants.CANCEL, style: .destructive, handler: nil)
        confirmationAlertContoller.addAction(confirmationAlertActionConfirm)
        confirmationAlertContoller.addAction(confirmationAlertActionCancel)
        present(confirmationAlertContoller, animated: true, completion: nil)
    }
    
    
}
