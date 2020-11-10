//
//  AccountDetailsViewController.swift
//  KitchenApp
//
//  Created by Techlocker on 23/10/20.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

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
            Utilities.removeUserDefaults()
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
    func showFormController(indexPath:IndexPath){
        let storyBoard = UIStoryboard(name: "FromStoryboard", bundle: .main)
        let formViewController = storyBoard.instantiateViewController(identifier: FormViewController.STORYBOARD_IDENTIFIER) as! FormViewController
        formViewController.titleLabel = accountParams[indexPath.row]
        formViewController.value = getUserInfo(titleLabel: accountParams[indexPath.row])
        formViewController.responseDelegate = self
        present(formViewController, animated: true, completion: nil)
        
    }

    func getUserInfo(titleLabel:String) -> String? {
        if titleLabel == Constants.ACCOUNT_PASSWORD_PARAM{
            return "*******"
        }else if titleLabel == Constants.ACCOUNT_KITCHEN_NAME_PARAM{
            return Utilities.homeKitchenName
        } else if titleLabel == Constants.ACCOUNT_KITCHEN_OWNER_PARAM {
            return Utilities.homeKitchenOwner
        } else if titleLabel == Constants.ACCOUNT_KITCHEN_CONTACT_NUMBER_PARAM {
            return Utilities.homeKitchenContactNumber
        } else {
            return Utilities.homeKitchenAddress
        }
        
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
      
        if indexPath.section == ACCOUNT_PARAM_SECTION{
            let cell = tableView.dequeueReusableCell(withIdentifier: AccounTableViewCell.CELL_IDENTIFIER, for: indexPath) as! AccounTableViewCell
            cell.accountDetailsLabel.text = accountParams[indexPath.row]
            
            if accountParams[indexPath.row] == Constants.ACCOUNT_PASSWORD_PARAM{
                cell.accountDetailsValue.text = "*******"
            }else if accountParams[indexPath.row] == Constants.ACCOUNT_KITCHEN_NAME_PARAM{
                cell.accountDetailsValue.text = Utilities.homeKitchenName
            } else if accountParams[indexPath.row] == Constants.ACCOUNT_KITCHEN_OWNER_PARAM {
                cell.accountDetailsValue.text = Utilities.homeKitchenOwner
            } else if accountParams[indexPath.row] == Constants.ACCOUNT_KITCHEN_CONTACT_NUMBER_PARAM {
                cell.accountDetailsValue.text = Utilities.homeKitchenContactNumber
            } else {
                cell.accountDetailsValue.text = Utilities.homeKitchenAddress
            }
            cell.accessoryType = .disclosureIndicator
        
            return cell
        }
            
        let cell = UITableViewCell()
        cell.textLabel?.text = "SignOut"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == ACCOUNT_SIGNOUT_SECTION {
            signOut()
            return
        }
        showFormController(indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == ACCOUNT_PARAM_SECTION {
            return Constants.ACCOUNT_PARAM_SECTION_HEADER
        }
        return Constants.ACCOUNT_SIGNOUT_SECTION_HEADER
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == ACCOUNT_PARAM_SECTION{
            return CGFloat(88)
        }
        return CGFloat(44)
    }
}

extension AccountDetailsViewController:ResponseDelegate{
    
    func onUpdateResponse(status: Bool,updateField:String?) {
        if status {
            guard let updateField = updateField else {return}
            print(Utilities.homeKitchenName)
            accountTableView.reloadData()
            present(Utilities.showMessage(title: Constants.SUCCESS, message: "\(updateField) Update Successfull"), animated: true, completion: nil)
        } else {
            
        }
       
    }
}


