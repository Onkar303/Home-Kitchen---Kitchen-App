//
//  AccountDetailsViewController.swift
//  KitchenApp
//
//  Created by Techlocker on 23/10/20.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

class AccountDetailsViewController: UIViewController {


    @IBOutlet weak var accountTableView: UITableView!
    
    var imagePicker:UIImagePickerController?
    var authController:Auth?
    var kitcheImage:UIImage?
    var accountParams:[String] = Constants.ACCOUNT_INFO_PARAMS
    var fireStorage:Storage?
    var firebaseStorageReference:StorageReference?
    
    let ACCOUNT_IMAGE_SECTION = 0
    let ACCOUNT_PARAM_SECTION = 1
    let ACCOUNT_SIGNOUT_SECTION = 2
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureFirebase()
        attachDelegates()
        configureUI()
        // Do any additional setup after loading the view.
    }
    
    
    //MARK:- Instanitate Auth
    func configureFirebase(){
        authController = Auth.auth()
        fireStorage = Storage.storage()
      
        
    }
    
    func generateRandomString()->String{
        return UUID().uuidString
    }
    
    //MARK:- Configure UI
    func configureUI(){
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.largeTitleDisplayMode = .automatic
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
    
    //MARK:- Uploading Image to FireBase
    func uploadImage(){
        firebaseStorageReference = fireStorage?.reference()
        let imageName = generateRandomString()
        guard let data = kitcheImage?.pngData() else {return}
        firebaseStorageReference?.child("HomeKitchenImages/"+imageName+".png").putData(data, metadata: nil, completion: { (storageMetaData, error) in
            if let error = error {
                print("error upload file \(error)")
            }
            
            self.firebaseStorageReference?.child("HomeKitchenImages/"+imageName+".png").downloadURL(completion: { (url, error) in
                let url = url!.absoluteURL
                print(url)
            })
        })
        
      
    }
    
    
    //MARK:- Handling Signout Tapped
    @IBAction func signOutTapped(_ sender: Any) {
        signOut()
    }
    
    //MARK:- Presenting FormController Modally
    func showFormController(indexPath:IndexPath,enableDropDown:Bool){
        let storyBoard = UIStoryboard(name: "FromStoryboard", bundle: .main)
        let formViewController = storyBoard.instantiateViewController(identifier: FormViewController.STORYBOARD_IDENTIFIER) as! FormViewController
        formViewController.titleLabel = accountParams[indexPath.row]
        formViewController.enableDropDown = enableDropDown
        formViewController.value = getUserInfo(titleLabel: accountParams[indexPath.row])
        formViewController.responseDelegate = self
        present(formViewController, animated: true, completion: nil)
        
    }

    //MARK:- Fetching User Defaults Data
    func getUserInfo(titleLabel:String) -> String? {
        
        
        if titleLabel == Constants.ACCOUNT_PASSWORD_PARAM{
            return "*******"
        }else if titleLabel == Constants.ACCOUNT_KITCHEN_NAME_PARAM{
            return UserDefaults.standard.string(forKey: Constants.USERDEFAULTS_KITCEHNNAME)
        } else if titleLabel == Constants.ACCOUNT_KITCHEN_OWNER_PARAM {
            return UserDefaults.standard.string(forKey: Constants.USERDEFAULTS_KITCHENOWNER)
        } else if titleLabel == Constants.ACCOUNT_KITCHEN_CONTACT_NUMBER_PARAM {
            return UserDefaults.standard.string(forKey: Constants.USERDEFAULTS_KITCHENCONTACTNUMBER)
        } else if titleLabel == Constants.ACCOUNT_KITCHEN_CUISINE_PARAM{
            return UserDefaults.standard.string(forKey: Constants.USERDEFAULTS_KITCHENCUISINE)
        }
        else {
            return UserDefaults.standard.string(forKey: Constants.USERDEFAULTS_KITCHENADDRESS)
        }
        
    }
    
    //MARK:- Showing ImagePicker
    func showImagePicker(){
        imagePicker = UIImagePickerController()
        imagePicker?.delegate = self
        imagePicker?.allowsEditing = true
        present(imagePicker!, animated:true, completion: nil)
    }

    
}

//MARK:- Handling AccountTabaleView
extension AccountDetailsViewController:UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == ACCOUNT_IMAGE_SECTION {
            return 1
        }
        if section == ACCOUNT_PARAM_SECTION {
            return accountParams.count
        }
        
        return 1
   
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == ACCOUNT_IMAGE_SECTION {
            let cell = tableView.dequeueReusableCell(withIdentifier:AccountTableViewImageCell.CELL_IDENTIFIER , for: indexPath) as! AccountTableViewImageCell
            if kitcheImage != nil {
                cell.kitchenImageView.image = kitcheImage
            }
            cell.kitchenImageView.setRounded()
            return cell
        }
      
        if indexPath.section == ACCOUNT_PARAM_SECTION{
            let cell = tableView.dequeueReusableCell(withIdentifier: AccounTableViewCell.CELL_IDENTIFIER, for: indexPath) as! AccounTableViewCell
            cell.accountDetailsLabel.text = accountParams[indexPath.row]
            

            if accountParams[indexPath.row] == Constants.ACCOUNT_PASSWORD_PARAM{
                cell.accountDetailsValue.text = "*******"
            }else if accountParams[indexPath.row] == Constants.ACCOUNT_KITCHEN_NAME_PARAM{
                cell.accountDetailsValue.text = UserDefaults.standard.string(forKey: Constants.USERDEFAULTS_KITCEHNNAME)
            } else if accountParams[indexPath.row] == Constants.ACCOUNT_KITCHEN_OWNER_PARAM {
                cell.accountDetailsValue.text = UserDefaults.standard.string(forKey: Constants.USERDEFAULTS_KITCHENOWNER)
            } else if accountParams[indexPath.row] == Constants.ACCOUNT_KITCHEN_CONTACT_NUMBER_PARAM {
                cell.accountDetailsValue.text = UserDefaults.standard.string(forKey: Constants.USERDEFAULTS_KITCHENCONTACTNUMBER)
            }else if accountParams[indexPath.row] == Constants.ACCOUNT_KITCHEN_CUISINE_PARAM {
                cell.accountDetailsValue.text = UserDefaults.standard.string(forKey: Constants.USERDEFAULTS_KITCHENCUISINE)
            }else {
                cell.accountDetailsValue.text = UserDefaults.standard.string(forKey: Constants.USERDEFAULTS_KITCHENADDRESS)
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
        
        if indexPath.section == ACCOUNT_IMAGE_SECTION {
            showImagePicker()
            return
        }
        
        if indexPath.section == ACCOUNT_PARAM_SECTION , accountParams[indexPath.row] == Constants.ACCOUNT_KITCHEN_CUISINE_PARAM{
            showFormController(indexPath: indexPath,enableDropDown: true)
        }
        
        if indexPath.section == ACCOUNT_SIGNOUT_SECTION {
            signOut()
            return
        }
        showFormController(indexPath: indexPath,enableDropDown: false)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if section == ACCOUNT_IMAGE_SECTION {
            return Constants.ACCOUNT_KITCHEN_IMAGE_SECTION_HEADER
        }
        
        if section == ACCOUNT_PARAM_SECTION {
            return Constants.ACCOUNT_PARAM_SECTION_HEADER
        }
        return Constants.ACCOUNT_SIGNOUT_SECTION_HEADER
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == ACCOUNT_IMAGE_SECTION {
            return CGFloat(160)
        }
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

extension AccountDetailsViewController:UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        kitcheImage = info[.editedImage] as? UIImage
        accountTableView.reloadData()
        imagePicker?.dismiss(animated: true, completion: {
            self.uploadImage()
        })
        
    }
}


