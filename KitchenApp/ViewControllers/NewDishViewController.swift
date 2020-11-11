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
    @IBOutlet weak var newDishesSearchBar: UISearchBar!
    
    var cuisines = Constants.SPPONOCULAR_CUISINE_CATEGORY
    var dishes:[Dishes] = []
    var filteredDishes = [Dishes]()
    var databaseController:DatabaseController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        configureUI()
        attachDelegates()
        
    }
    
    //MARK:- Configure UI
    func configureUI(){
        newDishesSearchBar.showsCancelButton = true
        self.navigationItem.largeTitleDisplayMode = .never
        newDishesCategoryCollectionView.showsHorizontalScrollIndicator = false
    }
    
    
    //MARK:- configure Database Controller
    func configureDatabaseController(){
        databaseController = (UIApplication.shared.delegate as! AppDelegate).databaseController
    }
    
    //MARK:- Attach Delegates
    func attachDelegates(){
        newDishesCollectionView.delegate = self
        newDishesCollectionView.dataSource = self
        
        newDishesCategoryCollectionView.delegate = self
        newDishesCategoryCollectionView.dataSource = self
        
        
        newDishesSearchBar.delegate = self
        
       
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
//            cell.newDishImageView.layer.cornerRadius = 10
//            cell.newDishImageView.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
            cell.dishNameLabel.text = filteredDishes[indexPath.row].title
            //cell.newDishImageView.layer.cornerRadius = CGFloat(Constants.CORNER_RADIUS)
            
            
         
//            cell.layer.cornerRadius = 10
//            cell.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
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
           
            segueToAddDishScreen(dishId: filteredDishes[indexPath.row].id)
            return
        }
        fetchDishes(cuisineParam: cuisines[indexPath.row])
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == newDishesCollectionView {
            let height = view.frame.size.height
            let width = view.frame.size.width
                // in case you you want the cell to be 40% of your controllers view
            return CGSize(width: width, height: height * 0.35)
        }
        return CGSize()
    }
   
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        
        let configuration = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { (action) -> UIMenu? in
            let save = UIAction { (action) in
                //self.databaseController?.addDish(dishInformation: <#T##DishInformation?#>)
            }
            
            save.image = UIImage(systemName: "plus.rectangle.on.rectangle")
            save.title = "Save Offline"
            return UIMenu(title: "Options", image: nil, identifier: nil, options:.displayInline, children: [save])
        }
        
        return configuration
    }
}


//MARK:- Handling Search
extension NewDishViewController:UISearchBarDelegate{


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
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchDishes(searchText: searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        view.endEditing(true)
    }
    
    
}

//MARK:- HAndling keyboard
extension NewDishViewController{
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}


