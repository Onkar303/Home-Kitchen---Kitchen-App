//
//  AddDishesViewController.swift
//  KitchenApp
//
//  Created by Techlocker on 29/10/20.
//

import UIKit
import Firebase
import FirebaseFirestore

class AddDishViewController: UIViewController, UITextFieldDelegate {
    
    static let STORYBOARD_IDENTIFIER = "AddDishViewController"
    
    //    @IBOutlet weak var dishSummaryTextField: UILabel!
    
    //    @IBOutlet weak var dishNameLabel: UILabel!
    //    @IBOutlet weak var healthScoreLabel: UILabel!
    //    @IBOutlet weak var servingsLabel: UILabel!
    //    @IBOutlet weak var dishInformationLabel: UILabel!
    //
    //New Labels
    
    @IBOutlet weak var dishImage: UIImageView!
    @IBOutlet weak var dishInformationLabel: UILabel!
    @IBOutlet weak var priceValueTextField: UITextField!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var summaryInformationLabel: UILabel!
    @IBOutlet weak var servingInformationLabel: UILabel!
    @IBOutlet weak var readyInLabel: UILabel!
    @IBOutlet weak var healthScoreLabel: UILabel!
    @IBOutlet weak var vegLabel: UILabel!
    @IBOutlet weak var addDishButton: UIButton!
    
    var documentReference:DocumentReference?
    var fireStore:Firestore?
    var dishId:Int?
    var willAddDish:Bool?
    var dishInformation:DishInformation?
    var databaseController:DatabaseController?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        configureUI()
        configureFireStore()
        fetchDish()
        configureDatabaseController()
        addTapGesture()
        attachDelegate()
    }
    
    func attachDelegate()  {
        priceValueTextField.delegate = self
    }
    
    //MARK:- Cofigure UI
    func configureUI(){
        guard let willAddDish = willAddDish else {return}
        if !willAddDish {
            addDishButton.isHidden = true
            priceLabel.isHidden = true
            priceValueTextField.isHidden = true            
        } else {
            
        }
    }
    
    
    //MARK:- Configuring FireStore Instance
    //Successfully added initial data
    func configureFireStore(){
        fireStore = Firestore.firestore()
    }
    
    //MARK:- Configure Database Controller
    func configureDatabaseController(){
        databaseController = (UIApplication.shared.delegate as! AppDelegate).databaseController
    }
    
    
    // MARK:- Function for tap Gesture - Summary Label
    func addTapGesture(){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(segueToSummaryController))
        summaryInformationLabel.addGestureRecognizer(tapGesture)
        summaryInformationLabel.isUserInteractionEnabled = true
    }
    
    
    //MARK:- Going to Summary Controller
    @objc func segueToSummaryController(){
        let storyboard = UIStoryboard(name:"SummaryLabel", bundle: .main)
        let summaryController = storyboard.instantiateViewController(identifier: SummaryViewController.STORYBOARD_IDENTIFIER) as! SummaryViewController
        summaryController.summaryText = summaryInformationLabel.text
        present(summaryController, animated: true, completion: nil)
        
    }
    
    
    //MARK:- Handling add Dish Button
    @IBAction func addDishButton(_ sender: Any) {
        priceValidation()
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
                    self.dishInformationLabel.text = self.dishInformation?.title
                    self.summaryInformationLabel.text = Utilities.removeHtmlTags(text: self.dishInformation?.summary)
                    Utilities.getImage(url:self.dishInformation?.image, imageView: self.dishImage)
                    self.healthScoreLabel.text = String((self.dishInformation?.healthScore)!)
                    self.servingInformationLabel.text = String((self.dishInformation?.servings)!)
                    self.readyInLabel.text = String((self.dishInformation?.readyInMinutes)!)
                    self.vegLabel.text = (self.dishInformation?.vegetarian)! ? "Yes" : "No"
                }
            }catch let error{
                print("error parsing data \(error)")
            }
        }.resume()
    }
    
    
    //MARK:- Doing validation
    func priceValidation(){
        let inputStr:String = priceValueTextField.text ?? ""
        let alert = UIAlertController(title:"Alert" , message: "Please Enter the Price", preferredStyle:.alert )
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        if inputStr.isEmpty{
            alert.message = "Please Enter Dish Price To Proceed"
            self.present(alert, animated: true, completion: nil)
        }else{
            let inputInt = Int(inputStr)
            if (inputInt)! < 1{
                alert.message = "Enter Valid price"
                self.present(alert, animated: true, completion: nil)
            }else{
                print("Valid Price amount")
                addDishConfirmation()
            }
        }
    }
    
    
    
    
    //MARK:- Adding Confirmation Alert Controller
    func addDishConfirmation(){
        guard let dishTitle = dishInformation?.title else {return}
        
        let confirmationAlertContoller = UIAlertController(title:"Confirmation", message:"Are you sure you want to add '\(dishTitle)'", preferredStyle: .alert)
        let confirmationAlertActionConfirm = UIAlertAction(title: Constants.CONFIRM, style: .default) { (alertAction) in
            self.addDishForHomeKitchen()
        }
        let confirmationAlertActionCancel = UIAlertAction(title: Constants.CANCEL, style: .destructive, handler: nil)
        confirmationAlertContoller.addAction(confirmationAlertActionConfirm)
        confirmationAlertContoller.addAction(confirmationAlertActionCancel)
        present(confirmationAlertContoller, animated: true, completion: nil)
    }
    
    
    //MARK:- Adding Dish to FireBase
    func addDishForHomeKitchen(){
        
        guard let price = priceValueTextField.text, !price.isEmpty else {return}
        dishInformation?.price = Int(price)
        
        guard let dict = dishInformation?.converToDictionary() else {
            print("error sending data")
            return
        }
        
            
        
        guard let homeKitchenDishCollection = UserDefaults.standard.string(forKey:Constants.USERDEFAULTS_KITCHENDISHESCOLLECTIONREFERENCE) else {return}
        fireStore?.collection(homeKitchenDishCollection).addDocument(data:dict, completion: { (error) in
            if let error = error {
                print("error entering the data \(error)")
            }else{
                self.present(Utilities.showMessage(title:Constants.SUCCESS, message:"Dish Added Successfully!"), animated: true, completion: nil)
            }
        })
    }
    
    //MARK:- Adding dish to Local Database
    func addDishOffline() {
        databaseController?.addDish(dishInformation: dishInformation)
        databaseController?.saveChanges()
    }
    
    
    //
    //    //MARK:- Making the image rounded
    //    override func viewWillLayoutSubviews() {
    //      super.viewWillLayoutSubviews()
    //      print("viewWillLayoutSubviews")
    //      //dishImageView.layer.cornerRadius = dishImageView.frame.height / 2.0
    //    }
    //
    
}
