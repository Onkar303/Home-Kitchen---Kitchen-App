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
    var currentDishes = [DishInformation]()
    var filteredCurrentDishes = [DishInformation]()
    var databaseController:DatabaseController?
    var savedDishesFromDatabase = [DishesCoreDataEntity]()
    var filteredSavedDishesFromDatabase = [DishesCoreDataEntity]()
    
    var searchController:UISearchController!
    var areDishesFromDatabase = false
    
    let DATABASE_SECTION = 1
    let FIRESTORE_SECTION = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        configureFireStore()
        configureUI()
        attachDelegates()
        configureDatabaseController()
        
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        if areDishesFromDatabase {
          fetchSavedDishes()
          return
        }
        getDishesForList()
    }
    
    
    //MARK:- Configure Firebase
    func configureFireStore(){
        fireStore = Firestore.firestore()
    }
    
    //MARK:- Configure databae Controller
    func configureDatabaseController(){
        databaseController = (UIApplication.shared.delegate as! AppDelegate).databaseController
        
     }
    
    //MARK:- Configure the UI
    func configureUI(){
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.scopeButtonTitles = ["Online","Saved"]
        searchController.searchBar.showsScopeBar = true
        searchController.searchBar.delegate = self
        searchController.definesPresentationContext = true
        
        
        self.navigationItem.searchController = searchController
        self.navigationItem.hidesSearchBarWhenScrolling = true
        navigationController?.navigationBar.prefersLargeTitles = true
    
        navigationController?.navigationBar.sizeToFit()
        
    }
    
    //MARK:- Attach Delegates
    func attachDelegates(){
        currentDishesTableView.delegate = self
        currentDishesTableView.dataSource = self
        
        searchController.searchResultsUpdater = self
    }
    
    
    //MARK:- Check if document Exists
    func getDishesForList(){
        currentDishes.removeAll()
        filteredCurrentDishes.removeAll()
        guard let hash = UserDefaults.standard.string(forKey: Constants.USERDEFAULTS_KITCHENDISHESCOLLECTIONREFERENCE) else {return}
        let docReference = fireStore.collection(hash)
        docReference.getDocuments { (querySnapShot, error) in
            if let error = error {
                print(error)
            } else {
                querySnapShot?.documents.forEach({ (docSnapShot) in
                    let dish = self.convertToDishInformation(dishInformationDictionary: docSnapShot.data())
                    dish.documentID = docSnapShot.documentID
                    self.currentDishes.append(dish)
                    self.filteredCurrentDishes.append(dish)
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
    
    
    //MARK:- Seqgue To Add Dish View Controller to show details
    func segueToAddDishViewController(dishId:Int?){
        guard let dishId=dishId else {return}
        let storyBoard = UIStoryboard(name:"AddDishStoryboard", bundle: .main)
        let addDishViewController = storyBoard.instantiateViewController(identifier: AddDishViewController.STORYBOARD_IDENTIFIER) as! AddDishViewController
        addDishViewController.dishId = dishId
        self.navigationController?.pushViewController(addDishViewController, animated: true)
    }

    //MARK:- Segue To dishDetails View Controller
    func segueToDishDetailsViewController(indexPath:IndexPath?){
        guard let indexPath=indexPath else {return}
        let storyBoard = UIStoryboard(name:"DishDetailsStoryboard", bundle: .main)
        let dishDetailsViewController = storyBoard.instantiateViewController(identifier: DishDetailsViewController.STORYBOARD_IDENTIFIER) as! DishDetailsViewController
        dishDetailsViewController.dishInformation = filteredCurrentDishes[indexPath.row]
        self.navigationController?.present(dishDetailsViewController, animated: true, completion: nil)
    }
    
    //MARK:- fetch All Saved Dishes
    func fetchSavedDishes(){
        savedDishesFromDatabase.removeAll()
        filteredSavedDishesFromDatabase.removeAll()
        savedDishesFromDatabase.append(contentsOf: (databaseController?.fetchAllDishes())!)
        filteredSavedDishesFromDatabase.append(contentsOf:savedDishesFromDatabase)
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
        if areDishesFromDatabase {
            return filteredSavedDishesFromDatabase.count
        }
        return filteredCurrentDishes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CurrentDishesTableViewCell.CELL_IDENTIFIER, for: indexPath) as! CurrentDishesTableViewCell
        if areDishesFromDatabase {
            Utilities.getImage(url: filteredSavedDishesFromDatabase[indexPath.row].image, imageView: cell.currentDIshesImageView)
            cell.currentDIshesImageView.clipsToBounds = true
            cell.currentDIshesImageView.layer.cornerRadius = cell.currentDIshesImageView.layer.frame.width / 2
            cell.currentDishesLabel.text = filteredSavedDishesFromDatabase[indexPath.row].title
            return cell
        }
        
        Utilities.getImage(url: filteredCurrentDishes[indexPath.row].image, imageView: cell.currentDIshesImageView)
        cell.currentDIshesImageView.clipsToBounds = true
        cell.currentDIshesImageView.layer.cornerRadius = cell.currentDIshesImageView.layer.frame.width / 2
        cell.currentDishesLabel.text = filteredCurrentDishes[indexPath.row].title
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete,!areDishesFromDatabase{
            print("delete")
            deleteDish(documentId: filteredCurrentDishes[indexPath.row].documentID)
            self.currentDishes.remove(at: indexPath.row)
            self.filteredCurrentDishes.remove(at: indexPath.row)
            self.currentDishesTableView.deleteRows(at: [indexPath], with: .left)
            
        } else if editingStyle == .delete, areDishesFromDatabase {
            databaseController?.deleteDish(dish: savedDishesFromDatabase[indexPath.row])
            databaseController?.saveChanges()
            savedDishesFromDatabase.remove(at: indexPath.row)
            filteredSavedDishesFromDatabase.remove(at: indexPath.row)
            currentDishesTableView.deleteRows(at: [indexPath], with: .left)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if areDishesFromDatabase {
            segueToAddDishViewController(dishId:Int(filteredSavedDishesFromDatabase[indexPath.row].id))
            return
        }
        segueToDishDetailsViewController(indexPath:indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(132)
    }
    
    
}

//MARK:-Handling search
extension CurrentDishesViewController:UISearchResultsUpdating,UISearchBarDelegate{
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text, !searchText.isEmpty else {return}
        if areDishesFromDatabase {
            searchDishFromDatabase(searchText: searchText)
            return
        }
       
        searchDishFromFireStore(searchText:searchText)
    }
    

    func searchDishFromFireStore(searchText:String){
        filteredCurrentDishes = currentDishes.filter({ (dishInformation) -> Bool in
            guard let title = dishInformation.title, !title.isEmpty else {return false}
            if title.contains(searchText){
                return true
            }
            return false
        })
        currentDishesTableView.reloadData()
    }
    
    func searchDishFromDatabase(searchText:String){
        if searchText == "" {
            filteredSavedDishesFromDatabase.removeAll()
            filteredSavedDishesFromDatabase.append(contentsOf: savedDishesFromDatabase)
        } else {
            filteredSavedDishesFromDatabase = savedDishesFromDatabase.filter({ (dishCoreData) -> Bool in
                guard let title = dishCoreData.title else {return false}
                if title.contains(searchText) {return true}
                return false
            })
        }
        currentDishesTableView.reloadData()
    
        
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        if selectedScope == DATABASE_SECTION {
            fetchSavedDishes()
            areDishesFromDatabase = true
        } else {
            getDishesForList()
            areDishesFromDatabase = false
        }
        
        currentDishesTableView.reloadData()
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        if areDishesFromDatabase {
            filteredSavedDishesFromDatabase.removeAll()
            filteredSavedDishesFromDatabase.append(contentsOf: savedDishesFromDatabase)
        } else{
            filteredCurrentDishes.removeAll()
            filteredCurrentDishes.append(contentsOf: currentDishes)
        }
        currentDishesTableView.reloadData()
    }
}

//MARK:- Handle Editing
extension CurrentDishesViewController{
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
}
