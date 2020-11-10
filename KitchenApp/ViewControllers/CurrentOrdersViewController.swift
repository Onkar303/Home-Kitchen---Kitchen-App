//
//  CurrentOrdersViewController.swift
//  KitchenApp
//
//  Created by Techlocker on 23/10/20.
//

import UIKit

class CurrentOrdersViewController: UIViewController {

    @IBOutlet weak var currentOrdersTableView: UITableView!
    var currentOrders = [Any]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        attachDelegates()
        configureUI()

        // Do any additional setup after loading the view.
    }
    
    //MARK:- attaching delegates
    func attachDelegates(){
        currentOrdersTableView.delegate = self
        currentOrdersTableView.dataSource = self
    }
    
    func configureUI(){
        let searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        self.navigationItem.searchController = searchController
        self.navigationItem.searchController?.hidesBottomBarWhenPushed = false
       
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
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

extension CurrentOrdersViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    
    
}
