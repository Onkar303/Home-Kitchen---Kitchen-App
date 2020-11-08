//
//  CurrentDishesViewController.swift
//  KitchenApp
//
//  Created by Techlocker on 23/10/20.
//

import UIKit
import FirebaseFirestore

class CurrentDishesViewController: UIViewController {
    
    var fireStore:Firestore!
    @IBOutlet weak var currentDishesTableView: UITableView!
    var currentDishesList = [DishInformation]()
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        configureFireStore()
        configureUI()
        attachDelegates()
        
        
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        getDishesForList()
    }
    
    
    //MARK:- Configure Firebase
    func configureFireStore(){
        fireStore = Firestore.firestore()
    }
    
    //MARK:- Configure the UI
    func configureUI(){
        
        let searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        
        self.navigationItem.searchController = searchController
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.sizeToFit()
        
    }
    
    //MARK:- Attach Delegates
    func attachDelegates(){
        currentDishesTableView.delegate = self
        currentDishesTableView.dataSource = self
    }
    
    
    //MARK:- Check if document Exists
    func getDishesForList(){
        currentDishesList.removeAll()
        guard let hash = UserDefaults.standard.string(forKey: Constants.USERDEFAULTS_KITCHENDISHESCOLLECTIONREFERENCE) else {return}
        let docReference = fireStore.collection(hash)
        docReference.getDocuments { (querySnapShot, error) in
            if let error = error {
                print(error)
            } else {
                querySnapShot?.documents.forEach({ (docSnapShot) in
                    let dish = self.convertToDishInformation(dishInformationDictionary: docSnapShot.data())
                    dish.documentID = docSnapShot.documentID
                    self.currentDishesList.append(dish)
                })
                
                DispatchQueue.main.async {
                    self.currentDishesTableView.reloadData()
                }
            }
        }
    }
    
    
    //MARK:- Converting to HomeKitchen type
    func convertToDishInformation(dishInformationDictionary:[String:Any]) -> DishInformation{
        var data:DishInformation?
        do {
            let jsonData = try  JSONSerialization.data(withJSONObject: dishInformationDictionary, options: [])
            let jsonDecorer = JSONDecoder()
            data = try jsonDecorer.decode(DishInformation.self, from: jsonData)
            return data!
        }catch let error{
            print("error fetching data\(error)")
        }
        return data!
    }
    
    //MARK:- Deleting a Dish from Firestore
    func deleteDish(documentId:String?){
        guard let documentId = documentId else {return}
        fireStore.collection(UserDefaults.standard.string(forKey: Constants.USERDEFAULTS_KITCHENDISHESCOLLECTIONREFERENCE)!).document(documentId).delete()
    }
    
    
    
    //    //MARK:- Adding an Listner for change in database
    //    func addDishUpdateListner(){
    //        fireStore.collection(UserDefaults.standard.string(forKey:Constants.USERDEFAULTS_KITCHENDISHESCOLLECTIONREFERENCE)!).addSnapshotListener { (queryShanpshot, error) in
    //            guard let querySnapshot = queryShanpshot else {return}
    //
    //            querySnapshot.documentChanges.forEach { (documenChange) in
    //                if documenChange.type == .added{
    //                    self.currentDishesList.append(self.convertToDishInformation(dishInformationDictionary: documenChange.document.data()))
    //                }
    //
    //
    //                DispatchQueue.main.async {
    //                    self.currentDishesTableView.reloadData()
    //                }
    //            }
    //        }
    //    }
}


//MARK:- Handling the TableView
extension CurrentDishesViewController : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentDishesList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CurrentDishesTableViewCell.CELL_IDENTIFIER, for: indexPath) as! CurrentDishesTableViewCell
        cell.textLabel?.text = currentDishesList[indexPath.row].title
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            print("delete")
            deleteDish(documentId: currentDishesList[indexPath.row].documentID)
            
            self.currentDishesList.remove(at: indexPath.row)
            self.currentDishesTableView.deleteRows(at: [indexPath], with: .left)
            
        }
    }
    
    
}
