//
//  SummaryViewController.swift
//  KitchenApp
//
//  Created by user173285 on 11/20/20.
//

import UIKit

class SummaryViewController: UIViewController {
    static let STORYBOARD_IDENTIFIER = "SummaryViewController"
    
    
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var handleView: UIView!
    var summaryText:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setData()
    }
    
    //MARK:- Configuring UI
    func configureUI(){
        handleView.clipsToBounds = true
        handleView.layer.cornerRadius = handleView.frame.width/10
        
    }
    
    
    //MARK:- Setting data
    func setData(){
        guard let summaryText = summaryText else {return}
        summaryLabel.text = summaryText
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
