//
//  NewDishViewController.swift
//  KitchenApp
//
//  Created by Techlocker on 29/10/20.
//

import UIKit

class NewDishViewController: UIViewController {
    
    @IBOutlet weak var newDishesTableView: UITableView!
    var dishes:[Dishes] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        configureUI()
        attachDelegates()
        fetchDishes()
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
    
    
    //MARK:- Making Api Call
    func fetchDishes(){
        let url = Constants.SPOONOCULAR_BASE + Constants.SPOONOCULAR_KEYPARAM + Constants.SPOONOCULAR_KEY + Constants.SPOONOCULAR_CUISINEPARAM + "indian"
        URLSession.shared.dataTask(with: URL(string: url)!) { (data, urlResponse, error) in
            if let error = error {
                print("unable to fetch data \(error)")
            } else{
                do {
                    let jsonDecoder = JSONDecoder()
                    let dishData = try jsonDecoder.decode(DishResults.self, from: data!)
                    guard let dishResults = dishData.results else {return}
                    self.dishes.append(contentsOf:dishResults)
                    self.newDishesTableView.reloadData()
                }catch let error{
                  print("unable to decode data \(error)")
                }
            }
        }.resume()
    }
    
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
        return dishes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:NewDishTableViewCell.CELL_IDENTIFIER,for: indexPath) as! NewDishTableViewCell
        cell.dishNameLabel.text = dishes[indexPath.row].title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        segueToAddDishScreen()
    }    
    
}
