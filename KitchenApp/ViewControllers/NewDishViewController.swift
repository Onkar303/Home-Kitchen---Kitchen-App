//
//  NewDishViewController.swift
//  KitchenApp
//
//  Created by Techlocker on 29/10/20.
//

import UIKit

class NewDishViewController: UIViewController{
    
    @IBOutlet weak var newDishesCategoryCollectionView: UICollectionView!
    @IBOutlet weak var newDishesCollectionView: UICollectionView!
    
    var cuisines = Constants.SPPONOCULAR_CUISINE_CATEGORY
    var searchController:UISearchController!
    var dishes:[Dishes] = []
    var filteredDishes = [Dishes]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        configureUI()
        attachDelegates()
        
    }
    
    //MARK:- Configure UI
    func configureUI(){
        searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        
        self.navigationItem.searchController = searchController
        self.navigationController?.navigationBar.prefersLargeTitles = false
        	
        newDishesCategoryCollectionView.showsHorizontalScrollIndicator = false
        
        
    }
    
    //MARK:- Attach Delegates
    func attachDelegates(){
        newDishesCollectionView.delegate = self
        newDishesCollectionView.dataSource = self
        
        newDishesCategoryCollectionView.delegate = self
        newDishesCategoryCollectionView.dataSource = self
        
        searchController.searchResultsUpdater = self
       
    }
    
    
    //MARK:- Making Api Call
    func fetchDishes(cuisineParam:String?){
        
        guard let cuisineParam = cuisineParam else {return}
        
        dishes.removeAll()
        filteredDishes.removeAll()
        
        let url = Constants.SPOONOCULAR_BASE + Constants.SPOONOCULAR_COMPLEXPARAM + Constants.SPOONOCULAR_KEYPARAM + Constants.SPOONOCULAR_KEY + Constants.SPOONOCULAR_CUISINEPARAM + cuisineParam
        URLSession.shared.dataTask(with: URL(string: url)!) { (data, urlResponse, error) in
            if let error = error {
                print("unable to fetch data \(error)")
            } else{
                do {
                    let jsonDecoder = JSONDecoder()
                    let dishData = try jsonDecoder.decode(DishResults.self, from: data!)
                    guard let dishResults = dishData.results else {return}
                    self.dishes.append(contentsOf:dishResults)
                    self.filteredDishes.append(contentsOf: dishResults)
                    DispatchQueue.main.async {
                        self.newDishesCollectionView.reloadData()
                    }
                }catch let error{
                  print("unable to decode data \(error)")
                }
            }
        }.resume()
    }
    
    //MARK:- Segue To Add Dish Screen To Add New Dish
    func segueToAddDishScreen(dishId:Int?){
        let storyBoard = UIStoryboard(name: "AddDishStoryboard", bundle: .main)
        let addDishViewController = storyBoard.instantiateViewController(withIdentifier: AddDishViewController.SCREEN_IDENTIFIER) as! AddDishViewController
        addDishViewController.dishId = dishId
        addDishViewController.willAddDish = true
        self.navigationController?.pushViewController(addDishViewController, animated: true)
    }
    
}
//
////MARK:- Delegate methods of Table View
//extension NewDishViewController:UITableViewDataSource,UITableViewDelegate{
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return filteredDishes.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier:NewDishTableViewCell.CELL_IDENTIFIER,for: indexPath) as! NewDishTableViewCell
//
//        cell.dishImageView.clipsToBounds = true
//        Utilities.getImage(url:filteredDishes[indexPath.row].image, imageView: cell.dishImageView)
//        //cell.dishImageView.setRounded()
//        cell.dishNameLabel.text = filteredDishes[indexPath.row].title
//
//        return cell
//    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
//        segueToAddDishScreen(dishId:dishes[indexPath.row].id)
//    }
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return CGFloat(136)
//    }
//    
//}


//MARK:- Handling collectionView
extension NewDishViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == newDishesCollectionView {
            return filteredDishes.count
        }
        return cuisines.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == newDishesCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewDishCollectionViewCell.CELL_IDENTIFIER, for: indexPath) as! NewDishCollectionViewCell
            
            Utilities.getImage(url:filteredDishes[indexPath.row].image, imageView: cell.newDishImageView)
            cell.newDishImageView.clipsToBounds = true
            //cell.newDishImageView.layer.cornerRadius = CGFloat(Constants.CORNER_RADIUS)
            
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DishCategoryCollectionViewCell.CELL_IDENITIFIER, for:indexPath) as! DishCategoryCollectionViewCell
        
        cell.layer.borderWidth = 1
        cell.layer.borderColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        cell.layer.cornerRadius = 10
        cell.categoryLabel.text = cuisines[indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == newDishesCollectionView {
          
            return
        }
        fetchDishes(cuisineParam: cuisines[indexPath.row])
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == newDishesCollectionView {
            return CGSize(width: 300, height: 300)
        }
        return CGSize()
    }
}


//MARK:- Handling Search
extension NewDishViewController:UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text,!searchText.isEmpty else {return}
        searchDishes(searchText: searchText)
    }

    func searchDishes(searchText:String){
        
        if searchText.isEmpty{
            filteredDishes.removeAll()
            filteredDishes.append(contentsOf:dishes)
        } else{
            filteredDishes = dishes.filter({ (dishes) -> Bool in
                guard let title = dishes.title , !title.isEmpty else {return false}
                if title.contains(searchText) {
                    return true
                }
                return false
            })
        }
        newDishesCollectionView.reloadData()
    }
}

//MARK:- HAndling keyboard
extension NewDishViewController{
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}
