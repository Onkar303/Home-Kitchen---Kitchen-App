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
    var summaryText:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
