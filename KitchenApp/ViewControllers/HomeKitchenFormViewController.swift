//
//  HomeKitchenFormViewController.swift
//  KitchenApp
//
//  Created by Techlocker on 6/11/20.
//

import UIKit
import FirebaseFirestore
import FirebaseStorage

class HomeKitchenFormViewController: UIViewController{

    static let STORYBOARD_IDENTIFIER = "HomeKitchenFormViewController"
    
    @IBOutlet weak var kitchenImageView: UIImageView!
    @IBOutlet weak var kitchenNameTextField: UITextField!
    @IBOutlet weak var KitchenAddressTextField: UITextField!
    @IBOutlet weak var kitchenOwnerTextField: UITextField!
    @IBOutlet weak var kitchenContactNumberTextField: UITextField!
    @IBOutlet weak var foodHandlingCertificateTextField: UITextField!
    @IBOutlet weak var foodHygineCertificateTextField: UITextField!
    
    var kitchenId:String?
    var fireStore:Firestore?
    var fireStorage:Storage?
    var fireStorageReference:StorageReference?
    var imagePicker:UIImagePickerController!
    var imageUrl:Any?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureFireBase()
        addTapGesture()
        configureUI()
        attachDelegates()
        // Do any additional setup after loading the view.
    }
    
    //MARK:- Handling tapped signup button
    @IBAction func createKitchenTapped(_ sender: Any) {
        setHomeKitchen()
    }
    
    //MARK:- attaching Delegates
    func attachDelegates(){
        kitchenNameTextField.delegate = self
        KitchenAddressTextField.delegate = self
        kitchenOwnerTextField.delegate = self
        kitchenContactNumberTextField.delegate = self
        foodHandlingCertificateTextField.delegate = self
        foodHygineCertificateTextField.delegate = self
    }
    
    //MARK:- Configuring FireStore
    func configureFireBase(){
        fireStore = Firestore.firestore()
        fireStorage = Storage.storage()
        fireStorageReference = fireStorage?.reference(withPath:"HomeKitchensImage")
        
    }
    
    
    //MARK:- Adding tap Gesture
    func addTapGesture(){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(selectImageFromStorage))
        kitchenImageView.addGestureRecognizer(tapGesture)
        kitchenImageView.isUserInteractionEnabled = true
    }
    
    //MARK:- selecting imageFromStorage
    @objc func selectImageFromStorage(){
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    
    //MARK:- ConfigureUI
    func configureUI(){
        kitchenImageView.setRounded()
    }
    
    //MARK:- Send data to FireStore
    func setHomeKitchen(){
        guard let hash = kitchenId,!hash.isEmpty else {return }
        let docReference = fireStore?.collection(Constants.FIRE_STORE_HOME_KITCHEN_COLLECTION_NAME).document(hash)
        if isFormFilled() {
            docReference?.setData(createFireStoreDict(), completion: { (error) in
                if let error = error {
                    print("error in sending data to the firebase \(error)")
                } else {
                    self.getHomeKitchen()
                    self.segueToHomeContoller()
                }
            })
        } else {
            present(Utilities.showMessage(title: "Alert!", message: "Please enter the entire form to proceed!"), animated: true, completion: nil)
        }
    }
    
    //MARK:- Creating OrderCollection and DishCollection New Collection
//    func createNewCollection(){
//        let docReference = fireStore?.collection()
//    }
//    
    
    //MARK:- Validating if Form is filled
    func isFormFilled() -> Bool{
        guard let kitchenName = kitchenNameTextField.text, !kitchenName.isEmpty else {return false}
        guard let kitchenAddress = KitchenAddressTextField.text, !kitchenAddress.isEmpty else {return false}
        guard let kitchenOwner = kitchenOwnerTextField.text, !kitchenOwner.isEmpty else {return false}
        guard let kitcheContactNumber = kitchenContactNumberTextField.text , !kitcheContactNumber.isEmpty else {return false}
        guard let foodHandlingCertificate = foodHandlingCertificateTextField.text , !foodHandlingCertificate.isEmpty else {return false}
        guard let foodAndHyginerCertificate = foodHygineCertificateTextField.text, !foodAndHyginerCertificate.isEmpty else {return false}
        return true
    }
    
    //MARK:- Uploading image To firebase
    func uploadImageToFirebase(imageData:Data?,completion: @escaping (String)->Void){
        guard let data = imageData  else { return }
        let path = Constants.FIRE_STORAGE_IMAGE_FOLDER_NAME+"/"+UUID().uuidString+".png"
        fireStorageReference?.child(path).putData(data, metadata: nil, completion: { (storageMetaData, error) in
            guard let metaData = storageMetaData else {
                return
            }
            self.fireStorageReference?.child(path).downloadURL(completion: { (url, error) in
                guard let url = url  else {return}
                //UserDefaults.standard.setValue(url, forKey: Constants.USERDEFAULTS_KITCHENIMAGEURL)
                completion(url.absoluteString)
            })
            
        })
    }
    
    
    //MARK:-- create dictionary for FireStore
    func createFireStoreDict() -> [String:Any]{
        let newHomeKitchen = HomeKitchen()
        
        newHomeKitchen.kitchenId = kitchenId
        newHomeKitchen.kitchenName = kitchenNameTextField.text
        newHomeKitchen.kitchenOwner = kitchenOwnerTextField.text
        newHomeKitchen.kitchenAddress = KitchenAddressTextField.text
        newHomeKitchen.kitchenContactNumber = kitchenContactNumberTextField.text
        let newUser = User(userName:UserDefaults.standard.string(forKey: Constants.USERDEFAULTS_USERNAME) , password:UserDefaults.standard.string(forKey: Constants.USERDEFAULTS_PASSOWRD))
        newHomeKitchen.userCredentials = newUser
        newHomeKitchen.kitchenDishesCollectionReference = Utilities.MD5(string:kitchenNameTextField.text! + String(Utilities.currentTimeInSeconds()))
        newHomeKitchen.kitchenOrdersCollectionReference = Utilities.MD5(string:newUser.userName! + newUser.password! + kitchenId!)
        newHomeKitchen.foodHandlingCertificate = foodHandlingCertificateTextField.text
        newHomeKitchen.foodAndHygineCertificate = foodHygineCertificateTextField.text
        
        let semaphore = DispatchSemaphore.init(value:1)
        
        uploadImageToFirebase(imageData: kitchenImageView.image?.pngData(), completion: { (url) in
            newHomeKitchen.kitchenImageURL = url
            semaphore.signal()
        })
        semaphore.wait()
        
        return newHomeKitchen.convertToDictionary()
    }
    
    //MARK:- get Home Kkitchen
    func getHomeKitchen(){
        guard let kitchenId = kitchenId else {return}
        fireStore?.collection(Constants.FIRE_STORE_HOME_KITCHEN_COLLECTION_NAME).document(kitchenId).getDocument(completion: { (docSnapShot, error) in
            if let error = error {
                print("error is setting user defaults \(error)")
                return
            }
            Utilities.setUserDefaults(homeKitchenDictionary:docSnapShot?.data())
        })
    }
    
    
    //MARK:- Segue to Home Controller
    func segueToHomeContoller(){
        let storyboard = UIStoryboard(name:"Main", bundle:.main)
        let tabBarController = storyboard.instantiateViewController(withIdentifier:"tabBarController")
        self.navigationController?.pushViewController(tabBarController, animated: true)
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


//MARK:- Handling the keyboard
extension HomeKitchenFormViewController:UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        kitchenNameTextField.resignFirstResponder()
        KitchenAddressTextField.resignFirstResponder()
        kitchenOwnerTextField.resignFirstResponder()
        kitchenContactNumberTextField.resignFirstResponder()
        foodHandlingCertificateTextField.resignFirstResponder()
        foodHygineCertificateTextField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}


extension HomeKitchenFormViewController:UIImagePickerControllerDelegate & UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageUrl = info[.imageURL]
        guard let image = info[.editedImage] as? UIImage else {return}
        kitchenImageView.image = image
        kitchenImageView.setRounded()
        imagePicker.dismiss(animated: true, completion: nil)
    }
}
