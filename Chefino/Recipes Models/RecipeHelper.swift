//
//  RecipeHelper.swift
//  Chefino
//
//  Created by Mehmet Akkavak on 9.06.2024.
//
import CoreData

struct RecipeHelper {
    static func fetchAllRecipes(context: NSManagedObjectContext) -> [DishEntity] {
        let fetchRequest: NSFetchRequest<DishEntity> = DishEntity.fetchRequest()
        
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Failed to fetch recipes: \(error)")
            return []
        }
    }

    static func toggleFavorite(recipe: DishEntity, context: NSManagedObjectContext) {
        recipe.isFavorite.toggle()
        
        do {
            try context.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}
