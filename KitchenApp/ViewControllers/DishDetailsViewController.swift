//
//  DishDetailsViewController.swift
//  KitchenApp
//
//  Created by Techlocker on 20/11/20.
//

import Foundation
import UIKit


class DishDetailsViewController:UIViewController{
    
    @IBOutlet weak var dishImageView: UIImageView!
    @IBOutlet weak var dishNameLabel: UILabel!
    @IBOutlet weak var dishSummaryLabel: UILabel!
    @IBOutlet weak var servingsLabel: UILabel!
    @IBOutlet weak var readInLabel: UILabel!
    @IBOutlet weak var healthScoreLabel: UILabel!
    @IBOutlet weak var vegeterianLabel: UILabel!
    @IBOutlet weak var dishPriceLabel: UILabel!
    
    var dishId:Int?
    var dishInformation:DishInformation?
    static let STORYBOARD_IDENTIFIER = "DishDetailsViewController"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addTapGestureForSummary()
        setData()
        //fetchDish()
        
    }
    
    
    //MARK:- Setting data
    func fetchDish(){
        guard let dishId = dishId else{return}
        let url = Constants.SPOONOCULAR_BASE + "\(dishId)/" + Constants.SPOONOCULAR_INFORMATIONPARAM  + Constants.SPOONOCULAR_KEYPARAM+Constants.SPOONOCULAR_KEY
    
        URLSession.shared.dataTask(with: URL(string: url)!) { [self] (data, urlResponse, error) in
            if let error = error {
                print("error iun fetching Dish\(error)")
                return
            }
            
            guard let data = data else {return}
            do {
                let jsonDecoder = JSONDecoder()
                dishInformation = try jsonDecoder.decode(DishInformation.self, from: data)
                DispatchQueue.main.async {
                    self.dishNameLabel.text = dishInformation?.title
                    self.dishSummaryLabel.text = Utilities.removeHtmlTags(text: dishInformation?.summary)
                    Utilities.getImage(url:dishInformation?.image, imageView: self.dishImageView)
                    self.healthScoreLabel.text = String((dishInformation?.healthScore)!)
                    self.servingsLabel.text = String((dishInformation?.servings)!)
                    self.readInLabel.text = String((dishInformation?.readyInMinutes)!)
                    self.vegeterianLabel.text = (dishInformation?.vegetarian)! ? "Yes" : "No"
                }
            }catch let error{
                print("error parsing data \(error)")
            }
        }.resume()
    }
    
    
    //MARK:- Set Data
    func setData(){
        
        dishNameLabel.text = dishInformation?.title
        dishSummaryLabel.text = Utilities.removeHtmlTags(text: dishInformation?.summary)
        Utilities.getImage(url:dishInformation?.image, imageView: self.dishImageView)
        healthScoreLabel.text = String((dishInformation?.healthScore)!)
        servingsLabel.text = String((dishInformation?.servings)!)
        readInLabel.text = String((dishInformation?.readyInMinutes)!)
        vegeterianLabel.text = (dishInformation?.vegetarian)! ? "Yes" : "No"
        dishPriceLabel.text = String((dishInformation?.price)!)
  
    }
    
    
    func addTapGestureForSummary(){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showSummaryViewController))
        dishSummaryLabel.addGestureRecognizer(tapGesture)
        dishSummaryLabel.isUserInteractionEnabled = true
    }
    
    @objc func showSummaryViewController(){
        presentSummaryViewController()
    }
    
    //MARK:- present Summary Controller
    func presentSummaryViewController(){
        guard let dishInformation = dishInformation else {return}
        let storyBoard = UIStoryboard(name: "SummaryLabel", bundle: .main)
        let summaryViewController = storyBoard.instantiateViewController(identifier: SummaryViewController.STORYBOARD_IDENTIFIER) as! SummaryViewController
        summaryViewController.summaryText = Utilities.removeHtmlTags(text:dishInformation.summary)
        present(summaryViewController, animated: true, completion: nil)
    }
    
}
