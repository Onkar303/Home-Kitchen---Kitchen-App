//
//  OrderHistoryViewController.swift
//  KitchenApp
//
//  Created by Techlocker on 23/10/20.
//

import UIKit
import FirebaseFirestore

class OrderHistoryViewController: UIViewController {

    @IBOutlet weak var orderHistoryTableView: UITableView!
    
    var orderHistory = [Order]()
    var filteredOrderHistory = [Order]()
    var fireStore:Firestore?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        attachDelegates()
        configureUI()
        configureFireStore()
        fetchOrders()
    }
    
    
    
    //MARK:- Attaching Delegates
    func attachDelegates(){
        orderHistoryTableView.delegate = self
        orderHistoryTableView.dataSource = self
    }
    
    //MARK:- Add
    func configureFireStore(){
        fireStore = Firestore.firestore()
    }
    
    
    //MARK:- Configuring UI
    func configureUI(){
            
        let searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchResultsUpdater = self
        self.navigationItem.searchController = searchController
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    
    func fetchOrders(){
        orderHistory.removeAll()
        filteredOrderHistory.removeAll()
        guard let orderReference = UserDefaults.standard.string(forKey:Constants.USERDEFAULTS_KITCHENORDERSCOLLECTIONREFERENCE) else {return}
        fireStore?.collection(orderReference).whereField("isOrderCompleted", isEqualTo: true).addSnapshotListener({ (querySnapShot, error) in
            if let error = error {
                print("error fetching current Orders \(error)")
                return
            }
            
            let jsonDecoder = JSONDecoder()
            querySnapShot?.documents.forEach({ (docSnapShot) in
                do{
                    let jsonData = try JSONSerialization.data(withJSONObject: docSnapShot.data(), options: [])
                    let order = try jsonDecoder.decode(Order.self, from: jsonData)
                    
                    let orderDishData = try JSONSerialization.data(withJSONObject: docSnapShot.data()["dishToOrder"] as? [[String:Any]] , options: [])
                    let dishToOrderList = try jsonDecoder.decode([DishToOrder].self, from: orderDishData)
                    order.dishToOrder = dishToOrderList
                    self.orderHistory.append(order)
                    self.filteredOrderHistory.append(order)
                }catch let error{
                    print("error parsing data \(error)")
                }
            })
            
            DispatchQueue.main.async {
                self.orderHistoryTableView.reloadData()
            }
        
        })
    }
    
    
    //MARK:- showing details in OrderdetailsViewController
    func segueToOrderDetailsViewController(indexPath:IndexPath){
        let storyboard = UIStoryboard(name: "OrderDetailsStoryboard", bundle: .main)
        let orderDetailsViewController = storyboard.instantiateViewController(identifier:OrderDetailsViewController.STORYBOARD_IDENTIFIER) as! OrderDetailsViewController
        
        orderDetailsViewController.order = filteredOrderHistory[indexPath.row]
        present(orderDetailsViewController, animated: true, completion: nil)
    }
    

   

}


//MARK:- Handling Table View
extension OrderHistoryViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredOrderHistory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let historyCell = tableView.dequeueReusableCell(withIdentifier: OrderHistoryTableViewCell.CELL_IDENTIFIER, for: indexPath) as! OrderHistoryTableViewCell
        
        historyCell.numberOfDishes.text = "\(filteredOrderHistory[indexPath.row].dishToOrder!.count)"
        historyCell.customerName.text = "\(filteredOrderHistory[indexPath.row].customerName!)"
        historyCell.customerPhoneNumber.text = "\(filteredOrderHistory[indexPath.row].customerContactNumber!)"
        
        
        return historyCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        segueToOrderDetailsViewController(indexPath: indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    

}


extension OrderHistoryViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        searchDishes(searchText: searchController.searchBar.text!)
    }
    
    func searchDishes(searchText:String){
        if searchText.isEmpty{
            filteredOrderHistory.removeAll()
            filteredOrderHistory.append(contentsOf:orderHistory)
        } else{
            filteredOrderHistory = orderHistory.filter({ (order) -> Bool in
                guard let title = order.customerName , !title.isEmpty else {return false}
                if title.contains(searchText) {
                    return true
                }
                return false
            })
        }
        orderHistoryTableView.reloadData()
    }
    
    
}
