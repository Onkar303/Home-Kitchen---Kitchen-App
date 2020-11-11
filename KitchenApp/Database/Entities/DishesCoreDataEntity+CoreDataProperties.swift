//
//  DishesCoreDataEntity+CoreDataProperties.swift
//  KitchenApp
//
//  Created by Techlocker on 11/11/20.
//
//

import Foundation
import CoreData


extension DishesCoreDataEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DishesCoreDataEntity> {
        return NSFetchRequest<DishesCoreDataEntity>(entityName: "DishesCoreDataEntity")
    }

    @NSManaged public var id: Int64
    @NSManaged public var title: String?
    @NSManaged public var servings: Int64
    @NSManaged public var image: String?
    @NSManaged public var summary: String?
    @NSManaged public var readyInMinutes: Int64
    @NSManaged public var healthScore: Int64
    @NSManaged public var vegeterian: Bool
    @NSManaged public var vegan: Bool
    @NSManaged public var dairyFree: Bool
    @NSManaged public var varyPopular: Bool

}

extension DishesCoreDataEntity : Identifiable {

}
