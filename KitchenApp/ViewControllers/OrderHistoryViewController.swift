//
//  OrderHistoryViewController.swift
//  KitchenApp
//
//  Created by Techlocker on 23/10/20.
//

import UIKit

class OrderHistoryViewController: UIViewController {

    @IBOutlet weak var orderHistoryTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        attachDelegates()
        configureUI()
    }
    
    
    
    //MARK:- Attaching Delegates
    func attachDelegates(){
        orderHistoryTableView.delegate = self
        orderHistoryTableView.dataSource = self
    }
    
    
    //MARK:- Configuring UI
    func configureUI(){
            
        let searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        self.navigationItem.searchController = searchController
        
        self.navigationController?.navigationBar.prefersLargeTitles = true;
        
        
    
        
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


//MARK:- Handling Table View
extension OrderHistoryViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    
}
