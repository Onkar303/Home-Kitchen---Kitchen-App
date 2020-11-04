//
//  AccountDetailsViewController.swift
//  KitchenApp
//
//  Created by Techlocker on 23/10/20.
//

import UIKit
import FirebaseAuth

class AccountDetailsViewController: UIViewController {

    var authController:Auth?
    var accountParams:[String] = Constants.ACCOUNT_INFO_PARAMS
    @IBOutlet weak var accountTableView: UITableView!
    
    let ACCOUNT_PARAM_SECTION = 0
    let ACCOUNT_SIGNOUT_SECTION = 1
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        instantiateAuth()
        attachDelegates()
        configureUI()
        
        // Do any additional setup after loading the view.
    }
    
    
    //MARK:- Instanitate Auth
    func instantiateAuth(){
        authController = Auth.auth()
    }
    
    //MARK:- Configure UI
    func configureUI(){
        self.navigationController?.navigationBar.prefersLargeTitles = true
      
    }
    
    //MARK:- Attach Delegates
    func attachDelegates(){
        accountTableView.delegate = self
        accountTableView.dataSource = self
    }
    
    
    //MARK:- Handling signOut
    func signOut(){
        do {
            try authController?.signOut()
            changeRootController()
        } catch let err {
            print("error signinout \(err)")
        }
    }
    
    //MARK:- Chnaging Root Controller
    func changeRootController(){
        let storyBoard = UIStoryboard(name: "Main", bundle: .main)
        let loginViewController = storyBoard.instantiateViewController(withIdentifier: "LoginNavigationController")
        UIApplication.shared.windows.first?.rootViewController = loginViewController
    }
    
    
    //MARK:- Handling Signout Tapped
    @IBAction func signOutTapped(_ sender: Any) {
        signOut()
    }
    
    //MARK:- Presenting FormController Modally
    func showFormController(){
        let storyBoard = UIStoryboard(name: "FromStoryboard", bundle: .main)
        let formViewController = storyBoard.instantiateViewController(identifier: FormViewController.STORYBOARD_IDENTIFIER) as! FormViewController
        present(formViewController, animated: true, completion: nil)
        
    }
    
}

//MARK:- Handling AccountTabaleView
extension AccountDetailsViewController:UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == ACCOUNT_PARAM_SECTION {
            return accountParams.count
        }
        return 1
   
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AccounTableViewCell.CELL_IDENTIFIER, for: indexPath) as! AccounTableViewCell
        if indexPath.section == ACCOUNT_PARAM_SECTION{
            cell.textLabel?.text = accountParams[indexPath.row]
            cell.accessoryType = .disclosureIndicator
            cell.detailTextLabel?.text = "details"
            return cell
        }
        
        cell.textLabel?.text = "SignOut"
        cell.detailTextLabel?.text = ""
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == ACCOUNT_SIGNOUT_SECTION {
            signOut()
            return
        }
        showFormController()
        
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == ACCOUNT_PARAM_SECTION {
            return Constants.ACCOUNT_PARAM_SECTION_HEADER
        }
        return Constants.ACCOUNT_SIGNOUT_SECTION_HEADER
        
    }
}


