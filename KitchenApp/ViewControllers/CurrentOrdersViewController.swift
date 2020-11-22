//
//  CurrentOrdersViewController.swift
//  KitchenApp
//
//  Created by Techlocker on 23/10/20.
//

import UIKit
import FirebaseFirestore

class CurrentOrdersViewController: UIViewController {

    @IBOutlet weak var currentOrdersTableView: UITableView!
    var currentOrders = [Order]()
    var filteredOrders = [Order]()
    var fireStore:Firestore?
    
    let ORDERS_SECTION = 0
    let TOTAL_ORDERS_SECTION = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        attachDelegates()
        configureFirebase()
        fetchCurrentOrders()
        configureUI()

        // Do any additional setup after loading the view.
    }
    
    //MARK:- attaching delegates
    func attachDelegates(){
        currentOrdersTableView.delegate = self
        currentOrdersTableView.dataSource = self
    }
    
    //MARK:- Configure Firebase
    func configureFirebase(){
        fireStore = Firestore.firestore()
    }
    
    
    //MARK:- Current Orders
    func fetchCurrentOrders(){
        currentOrders.removeAll()
        filteredOrders.removeAll()
        guard let orderReference = UserDefaults.standard.string(forKey:Constants.USERDEFAULTS_KITCHENORDERSCOLLECTIONREFERENCE) else {return}
        fireStore?.collection(orderReference).whereField("isOrderCompleted", isEqualTo: false).addSnapshotListener({ (querySnapShot, error) in
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
                    self.currentOrders.append(order)
                    self.filteredOrders.append(order)
                }catch let error{
                    print("error parsing data \(error)")
                }
            })
            
            DispatchQueue.main.async {
                self.currentOrdersTableView.reloadData()
            }
        
        })
    }
    
    //MARK:- Configure UI
    func configureUI(){
        let searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        self.navigationItem.searchController = searchController
        self.navigationItem.searchController?.hidesBottomBarWhenPushed = false
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
    }
    
    //MARK:- showing details in OrderdetailsViewController
    func segueToOrderDetailsViewController(indexPath:IndexPath){
        let storyboard = UIStoryboard(name: "OrderDetailsStoryboard", bundle: .main)
        let orderDetailsViewController = storyboard.instantiateViewController(identifier:OrderDetailsViewController.STORYBOARD_IDENTIFIER) as! OrderDetailsViewController
        
        orderDetailsViewController.order = filteredOrders[indexPath.row]
        
        present(orderDetailsViewController, animated: true, completion: nil)
    }
    
    //MARK:- to update order at firebase
    func updateOrderCompleted(indexPath:IndexPath){
        fireStore?.collection(currentOrders[indexPath.row].kitchenOrderReference!).document(currentOrders[indexPath.row].orderId!).updateData(["isOrderCompleted" : true])
        fetchCurrentOrders()
      
    }

}

extension CurrentOrdersViewController:UITableViewDelegate,UITableViewDataSource{

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == ORDERS_SECTION {
            return filteredOrders.count
        }
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == ORDERS_SECTION {
            let orderCell = tableView.dequeueReusableCell(withIdentifier: CurrentOrdersTableViewCell.CELL_IDENTIFIER,for: indexPath) as! CurrentOrdersTableViewCell
            
            orderCell.numberOfDishes.text = "\(filteredOrders[indexPath.row].dishToOrder!.count)"
            orderCell.orderNumber.text = "Order Number: \(indexPath.row + 1)"
            orderCell.customerName.text = "\(filteredOrders[indexPath.row].customerName!)"
            orderCell.customerPhoneNumber.text = "\(filteredOrders[indexPath.row].customerContactNumber!)"
            return orderCell
        }
        
        let totalCell = UITableViewCell()
        totalCell.textLabel?.text = "Orders Left: \(String(currentOrders.count))"
        return totalCell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == ORDERS_SECTION {
           segueToOrderDetailsViewController(indexPath: indexPath)
           return
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == ORDERS_SECTION {
            return "Orders"
        }
        
        return "Total Orders"
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        if indexPath.section == ORDERS_SECTION {
            return .insert
        }
        return .none
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .insert
        {
           
        }
    }
    
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if indexPath.section == ORDERS_SECTION {
            let contextItem = UIContextualAction(style: .normal, title: "ORDER COMPLETED") { (contextualAction, view, boolValue) in
                  boolValue(true) // pass true if you want the handler to allow the action
                self.updateOrderCompleted(indexPath: indexPath)
              }
            contextItem.backgroundColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
            contextItem.image = UIImage(systemName: "checkmark")
            let swipeActions = UISwipeActionsConfiguration(actions: [contextItem])
            return swipeActions
        }
        return nil
    }
    
}

extension CurrentOrdersViewController:UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        searchDishes(searchText: searchController.searchBar.text!)
    }
    
    func searchDishes(searchText:String){
        if searchText.isEmpty{
            filteredOrders.removeAll()
            filteredOrders.append(contentsOf:currentOrders)
        } else{
            filteredOrders = currentOrders.filter({ (order) -> Bool in
                guard let title = order.customerName , !title.isEmpty else {return false}
                if title.contains(searchText) {
                    return true
                }
                return false
            })
        }
        currentOrdersTableView.reloadData()
    }
    
    
}
