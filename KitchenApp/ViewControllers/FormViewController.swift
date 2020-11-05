//
//  FormViewController.swift
//  KitchenApp
//
//  Created by Techlocker on 5/11/20.
//

import UIKit

class FormViewController: UIViewController {

    static let STORYBOARD_IDENTIFIER = "FromViewController"
    @IBOutlet weak var paramTitleLabel: UILabel!
    @IBOutlet weak var commonTextField: UITextField!
    
    var titleLabel:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        // Do any additional setup after loading the view.
    }
    
    //MARK:- Configuring UI
    func configureUI(){
        paramTitleLabel.text = titleLabel
    }
    
    //MARK:- Handling Save
    @IBAction func saveTapped(_ sender: Any) {
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
