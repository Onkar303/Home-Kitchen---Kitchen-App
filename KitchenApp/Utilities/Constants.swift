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
    
    
    //MARK:- AccountDetailsViewController
    static let ACCOUNT_INFO_PARAMS = ["Username","Password","Kitchen Name","Owner","Address"]
    static let ACCOUNT_PARAM_SECTION_HEADER = "Account"
    static let ACCOUNT_SIGNOUT_SECTION_HEADER = "Signout"
    
    
    
    
    //MARK:- Firestore Constants
    static let FIRE_STORE_HOME_KITCHEN_COLLECTION_NAME = "HomeKitchens"
    
    
 
    
    
    
    
    
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
}

