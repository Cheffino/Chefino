//
//  DishEntity+CoreDataProperties.swift
//  Chefino
//
//  Created by Mehmet Akkavak on 9.06.2024.
//
//

import Foundation
import CoreData

extension DishEntity {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<DishEntity> {
        return NSFetchRequest<DishEntity>(entityName: "DishEntity")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var title: String?
    @NSManaged public var ingredients: String?
    @NSManaged public var category: String?
    @NSManaged public var timestamp: Date?
    @NSManaged public var description1: String?
    @NSManaged public var description2: String?
    @NSManaged public var description3: String?
    @NSManaged public var description4: String?
    @NSManaged public var photo: Data?
    @NSManaged public var photo1: Data?
    @NSManaged public var photo2: Data?
    @NSManaged public var photo3: Data?
    @NSManaged public var isFavorite: Bool
    @NSManaged public var allergens: String?
    @NSManaged public var containsGluten: Bool
    @NSManaged public var containsDairy: Bool
    @NSManaged public var containsNuts: Bool
    @NSManaged public var containsSeafood: Bool
    @NSManaged public var containsSoy: Bool
    @NSManaged public var containsEggs: Bool
    @NSManaged public var containsFish: Bool
    @NSManaged public var containsPeanuts: Bool
    @NSManaged public var containsShellfish: Bool
    @NSManaged public var containsTreeNuts: Bool
    @NSManaged public var containsWheat: Bool
    @NSManaged public var containsSesame: Bool
    @NSManaged public var containsSulfites: Bool
    @NSManaged public var containsMustard: Bool
    @NSManaged public var containsCelery: Bool
    @NSManaged public var photoName: String?
    @NSManaged public var photoName1: String?
    @NSManaged public var photoName2: String?
    @NSManaged public var photoName3: String?
    @NSManaged public var favoriteCount: Int32
    @NSManaged public var tags: [String]?
    @NSManaged public var isVegan: Bool
    @NSManaged public var isVegetarian: Bool
}

extension DishEntity: Identifiable {}
