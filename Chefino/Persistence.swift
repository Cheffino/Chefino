//
//  Persistence.swift
//  Chefino
//
//  Created by Mehmet Akkavak on 8.06.2024.
import Foundation
import CoreData

class PersistenceController {
    static let shared = PersistenceController()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "Chefino")

        let description = container.persistentStoreDescriptions.first
        description?.shouldMigrateStoreAutomatically = true
        description?.shouldInferMappingModelAutomatically = true

        if inMemory {
            description?.url = URL(fileURLWithPath: "/dev/null")
        }

        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                // Daha detaylı hata loglaması
                print("Unresolved error \(error), \(error.userInfo)")
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }

            // Örnek verilerin daha önce eklenip eklenmediğini kontrol et
            if !UserDefaults.standard.bool(forKey: "didAddSampleRecipes") {
                DataHelpers.addSampleRecipes(context: self.container.viewContext)
                UserDefaults.standard.set(true, forKey: "didAddSampleRecipes")
            }
        }
    }

    func saveContext() {
        let context = container.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Daha detaylı hata loglaması
                let nserror = error as NSError
                print("Unresolved error \(nserror), \(nserror.userInfo)")
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    // UUID ataması eksik varlıkları kontrol et ve UUID ata
    func assignUUIDsIfNeeded() {
        let context = container.viewContext
        let fetchRequest: NSFetchRequest<DishEntity> = DishEntity.fetchRequest()
        do {
            let results = try context.fetch(fetchRequest)
            for result in results {
                if result.id == nil {
                    result.id = UUID()
                }
            }
            try context.save()
        } catch {
            let nserror = error as NSError
            print("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }

    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        // Test verisi ekleyebilirsiniz
        for index in 0..<10 {
            let newRecipe = DishEntity(context: viewContext)
            newRecipe.id = UUID()
            newRecipe.title = "Recipe \(index)"
            newRecipe.ingredients = "Ingredients \(index)"
            newRecipe.timestamp = Date()
            newRecipe.favoriteCount = Int32(index)
            newRecipe.category = "Bakery"
        }
        do {
            try viewContext.save()
        } catch {
            let nserror = error as NSError
            print("Unresolved error \(nserror), \(nserror.userInfo)")
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        return result
    }()
}
