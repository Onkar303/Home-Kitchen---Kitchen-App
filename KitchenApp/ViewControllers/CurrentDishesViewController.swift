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
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        configureFireStore()
        configureUI()
        attachDelegates()
        //getDocuments()
        
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
    
    
//    //MARK:- Check if document Exists
//    func getDocuments(){
//        let hash = Utilities.createHashWithCredentials()
//        let docReference = fireStore.collection("HomeKitchen").document("\(hash)")
//
//        docReference.getDocument { (docSnapShot, error) in
//            if let docSnapShot = docSnapShot, docSnapShot.exists {
//                print("document exists")
//            } else {
//                print("no document exists")
//            }
//        }
//    }
    
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension CurrentDishesViewController : UITableViewDelegate,UITableViewDataSource{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 30
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return UITableViewCell()
        
    }
    
    
}
