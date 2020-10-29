//
//  NewDishViewController.swift
//  KitchenApp
//
//  Created by Techlocker on 29/10/20.
//

import UIKit

class NewDishViewController: UIViewController {

    @IBOutlet weak var newDishesTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        configureUI()
        attachDelegates()
    }
    
    //MARK:- Configure UI
    func configureUI(){
        
        let searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        
        self.navigationItem.searchController = searchController
        
        
        
    }
    
    //MARK:- Attach Delegates
    func attachDelegates(){
        newDishesTableView.delegate = self
        newDishesTableView.dataSource = self
    }
    
    

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    //MARK:- Segue To Add Dish Screen
    func segueToAddDishScreen(){
        let storyBoard = UIStoryboard(name: "AddDishStoryboard", bundle: .main)
        let addDishViewController = storyBoard.instantiateViewController(withIdentifier: AddDishViewController.SCREEN_IDENTIFIER) as! AddDishViewController
        self.navigationController?.pushViewController(addDishViewController, animated: true)
    }

}

//MARK:- Delegate methods of Table View
extension NewDishViewController:UITableViewDataSource,UITableViewDelegate{

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
   }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        segueToAddDishScreen()
    }    
    
}
