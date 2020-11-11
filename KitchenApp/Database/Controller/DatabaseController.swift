//
//  DatabaseController.swift
//  KitchenApp
//
//  Created by Techlocker on 11/11/20.
//

import Foundation
import CoreData


class DatabaseController {
    
    var persistanceContainer:NSPersistentContainer
    var viewContext:NSManagedObjectContext
    
    
    init() {
    
        persistanceContainer = NSPersistentContainer(name: "DishesCoredata")
        persistanceContainer.loadPersistentStores { (persistanceDescription, error) in
            if let error = error {
                print("error initializing persistance container \(error)")
            }
        }
        
        viewContext = persistanceContainer.viewContext
    }
    
    
    //MARK:- Saving Changes
    func saveChanges(){
        do {
            if viewContext.hasChanges {
                try viewContext.save()
            }
        } catch let error {
            print("error saving data \(error)")
        }
    }
    
    
    //MARK:- Adding dish
    func addDish(dishInformation:DishInformation?){
        guard let dishInformation = dishInformation else {return}
        let dish = NSEntityDescription.insertNewObject(forEntityName:"DishesCoreDataEntity", into: viewContext) as! DishesCoreDataEntity
        dish.id = Int64(dishInformation.id!)
        dish.title = dishInformation.title
        dish.servings = Int64(dishInformation.servings!)
        dish.image = dishInformation.image
        dish.summary = dishInformation.summary
        dish.readyInMinutes = Int64(dishInformation.readyInMinutes!)
        dish.healthScore = Int64(dishInformation.healthScore!)
        dish.vegeterian = dishInformation.vegetarian!
        dish.vegan = dishInformation.vegan!
        dish.dairyFree = dishInformation.veryPopular!
        
    }
    
    
    //MARK:- fetch All Dishes
    func fetchAllDishes() -> [DishesCoreDataEntity]{
        var saveDishes = [DishesCoreDataEntity]()
        let request:NSFetchRequest<DishesCoreDataEntity> = DishesCoreDataEntity.fetchRequest()
        
        do {
            try saveDishes.append(contentsOf: viewContext.fetch(request))
            return saveDishes
        } catch let err {
            print("error fetching data \(err)")
        }
        
        return saveDishes
    }
    
    
    //MARK:- fetch All Dishes
    func deleteDish(dish:DishesCoreDataEntity){
        viewContext.delete(dish)
    }
    
    
}
