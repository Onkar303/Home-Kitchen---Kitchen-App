//
//  NewDishViewController.swift
//  KitchenApp
//
//  Created by Techlocker on 29/10/20.
//

import UIKit

class NewDishViewController: UIViewController {
    
    @IBOutlet weak var newDishesCategoryCollectionView: UICollectionView!
    @IBOutlet weak var newDishesTableView: UITableView!
    
    var cuisines = Constants.SPPONOCULAR_CUISINE_CATEGORY
    var dishes:[Dishes] = []
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
        self.navigationController?.navigationBar.prefersLargeTitles = false
        
        newDishesCategoryCollectionView.showsHorizontalScrollIndicator = false
        
 
        
    }
    
    //MARK:- Attach Delegates
    func attachDelegates(){
        newDishesTableView.delegate = self
        newDishesTableView.dataSource = self
        
        newDishesCategoryCollectionView.delegate = self
        newDishesCategoryCollectionView.dataSource = self
    }
    
    
    //MARK:- Making Api Call
    func fetchDishes(cuisineParam:String?){
        
        guard let cuisineParam = cuisineParam else {return}
        
        let url = Constants.SPOONOCULAR_BASE + Constants.SPOONOCULAR_KEYPARAM + Constants.SPOONOCULAR_KEY + Constants.SPOONOCULAR_CUISINEPARAM + cuisineParam
        URLSession.shared.dataTask(with: URL(string: url)!) { (data, urlResponse, error) in
            if let error = error {
                print("unable to fetch data \(error)")
            } else{
                do {
                    let jsonDecoder = JSONDecoder()
                    let dishData = try jsonDecoder.decode(DishResults.self, from: data!)
                    guard let dishResults = dishData.results else {return}
                    self.dishes.removeAll(keepingCapacity:true)
                    self.dishes.append(contentsOf:dishResults)
                    DispatchQueue.main.async {
                        self.newDishesTableView.reloadData()
                    }
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


//MARK:- Handling collectionView
extension NewDishViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cuisines.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewDishCollectionViewCell.CELL_IDENITIFIER, for:indexPath) as! NewDishCollectionViewCell
        
        cell.layer.borderWidth = 2
        cell.layer.borderColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        cell.layer.cornerRadius = 10
        cell.categoryLabel.text = cuisines[indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        fetchDishes(cuisineParam: cuisines[indexPath.row])
    }
}
