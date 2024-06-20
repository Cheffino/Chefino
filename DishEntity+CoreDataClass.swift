//
//  DishEntity+CoreDataClass.swift
//  Chefino
//
//  Created by Mehmet Akkavak on 9.06.2024.
//
//
import CoreData

@objc(DishEntity)
public class DishEntity: NSManagedObject {
    override public func awakeFromInsert() {
        super.awakeFromInsert()
        self.id = UUID()
    }
}
