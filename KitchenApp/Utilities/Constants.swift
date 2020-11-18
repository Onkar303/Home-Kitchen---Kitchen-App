//
//  Constants.swift
//  KitchenApp
//
//  Created by Techlocker on 23/10/20.
//

import Foundation


class Constants{
    
    static let CORNER_RADIUS = 20
    
    //MARK:- Spoonocaluar API Params0
    static let SPPONOCULAR_CUISINE_CATEGORY = ["African",
                                         "American",
                                         "British",
                                         "Cajun",
                                         "Caribbean",
                                         "Chinese",
                                         "Eastern European",
                                         "European",
                                         "French",
                                         "German",
                                         "Greek",
                                         "Indian",
                                         "Irish",
                                         "Italian",
                                         "Japanese",
                                         "Jewish",
                                         "Korean",
                                         "Latin American",
                                         "Mediterranean",
                                         "Mexican",
                                         "Middle Eastern",
                                         "Nordic",
                                         "Southern",
                                         "Spanish",
                                         "Thai",
                                         "Vietnamese"]
    
    static let SPOONOCULAR_BASE = "https://api.spoonacular.com/recipes/"
    static let SPOONOCULAR_KEY = "7197d6ced50f405c963c1ea1e7d24844"
    static let SPOONOCULAR_KEYPARAM = "&apiKey="
    static let SPOONOCULAR_CUISINEPARAM = "&cuisine="
    
    static let SPOONOCULAR_COMPLEXPARAM = "complexSearch?"
    static let SPOONOCULAR_INFORMATIONPARAM = "information?"
    
    //Indicates the number of results you want
    static let SPOONOCULAR_NUMBER = "&number="
    
    //Incudicates the number of result you want to skip
    static let SPOONOCULAR_OFFSET = "&offset="
    
    
    
    static let ADD = "Add"
    static let CANCEL = "Cancel"
    static let CONFIRM = "Confirm"
    static let SUCCESS = "SUCCESS"
    static let ERROR = "ERROR"
    
    
    //MARK:- AccountDetailsViewController
    static let ACCOUNT_PASSWORD_PARAM = "Password"
    static let ACCOUNT_KITCHEN_NAME_PARAM = "Kitchen Name"
    static let ACCOUNT_KITCHEN_OWNER_PARAM = "Owner"
    static let ACCOUNT_KITCHEN_ADDRESS_PARAM = "Address"
    static let ACCOUNT_KITCHEN_CONTACT_NUMBER_PARAM = "Contact Number"
    static let ACCOUNT_INFO_PARAMS = [ACCOUNT_PASSWORD_PARAM,ACCOUNT_KITCHEN_NAME_PARAM,ACCOUNT_KITCHEN_OWNER_PARAM,ACCOUNT_KITCHEN_ADDRESS_PARAM,ACCOUNT_KITCHEN_CONTACT_NUMBER_PARAM]
    static let ACCOUNT_PARAM_SECTION_HEADER = "Account"
    static let ACCOUNT_SIGNOUT_SECTION_HEADER = "Signout"
    static let ACCOUNT_KITCHEN_IMAGE_SECTION_HEADER = "Display Image"
    
    
    
    //MARK:- Firestore Constants
    static let FIRE_STORE_HOME_KITCHEN_COLLECTION_NAME = "HomeKitchens"
    static let FIRE_STORAGE_IMAGE_FOLDER_NAME = "HomeKitchenImages"
    
    
    
    //MARK:- Saved Information
    static let SAVED_INFO_TITLE = "Info"
    static let SAVED_INFO_MESSAGE = "These Dishes are added locally and will be lost if you delete the app."
    
    
    
    
    
}

//MARK:- User Default Constants
extension Constants{
    static let USERDEFAULTS_USERNAME = "email"
    static let USERDEFAULTS_PASSOWRD = "password"
    static let USERDEFAULTS_KITCHENID = "kitchenID"
    static let USERDEFAULTS_KITCEHNNAME = "kitchenName"
    static let USERDEFAULTS_KITCHENOWNER = "kitchenOwner"
    static let USERDEFAULTS_KITCHENADDRESS="kitchenAddress"
    static let USERDEFAULTS_KITCHENCONTACTNUMBER="kitchenContactNumber"
    static let USERDEFAULTS_KITCHENDISHESCOLLECTIONREFERENCE = "kitchenDishesCollectionReference"
    static let USERDEFAULTS_KITCHENORDERSCOLLECTIONREFERENCE = "kitchenOrdersCollectionReference"
    static let USERDEFAULTS_KITCHENIMAGEURL = "kitchenImageURL"
}

