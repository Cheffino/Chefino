//
//  AppDelegate.swift
//  Chefino
//
//  Created by Mehmet Akkavak on 9.06.2024.
//
import UIKit
import FirebaseCore
import FirebaseFirestore
import CoreData

class AppDelegate: UIResponder, UIApplicationDelegate {
    let persistenceController = PersistenceController.shared
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        
        let context = persistenceController.container.viewContext
        
        // Mevcut çift tarifleri temizleme işlemi
        removeDuplicateRecipes(context: context)
        
        // Firestore'dan veri çekme işlemi
        loadRecipesFromFirestore(context: context)
        
        // Tüm tarifleri yazdır (debug için)
        printAllRecipes(context: context)
        
        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        saveContext()
    }
    
    func saveContext() {
        let context = persistenceController.container.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func removeDuplicateRecipes(context: NSManagedObjectContext) {
        let fetchRequest: NSFetchRequest<DishEntity> = DishEntity.fetchRequest()
        
        do {
            let recipes = try context.fetch(fetchRequest)
            var uniqueRecipes = Set<String>()
            
            for recipe in recipes {
                if let id = recipe.id?.uuidString {
                    if uniqueRecipes.contains(id) {
                        context.delete(recipe)
                    } else {
                        uniqueRecipes.insert(id)
                    }
                }
            }
            
            try context.save()
        } catch {
            print("Failed to remove duplicate recipes: \(error)")
        }
    }
    
    func loadRecipesFromFirestore(context: NSManagedObjectContext) {
        let db = Firestore.firestore()
        db.collection("recipes").getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                for document in querySnapshot!.documents {
                    let data = document.data()
                    guard let recipeId = data["id"] as? String, !recipeId.isEmpty, UUID(uuidString: recipeId) != nil else {
                        print("Invalid or missing ID for recipe, skipping document")
                        continue
                    }
                    
                    // Mevcut tarifleri kontrol edin
                    let fetchRequest: NSFetchRequest<DishEntity> = DishEntity.fetchRequest()
                    fetchRequest.predicate = NSPredicate(format: "id == %@", recipeId)
                    
                    do {
                        let existingRecipes = try context.fetch(fetchRequest)
                        if existingRecipes.isEmpty {
                            // Eğer tarif yoksa ekleyin
                            let newRecipe = DishEntity(context: context)
                            newRecipe.id = UUID(uuidString: recipeId)
                            newRecipe.title = data["title"] as? String ?? ""
                            newRecipe.ingredients = data["ingredients"] as? String ?? ""
                            newRecipe.category = data["category"] as? String ?? ""
                            newRecipe.description1 = data["description1"] as? String ?? ""
                            newRecipe.description2 = data["description2"] as? String ?? ""
                            newRecipe.description3 = data["description3"] as? String ?? ""
                            newRecipe.description4 = data["description4"] as? String ?? ""
                            newRecipe.containsGluten = data["containsGluten"] as? Bool ?? false
                            newRecipe.containsDairy = data["containsDairy"] as? Bool ?? false
                            newRecipe.containsNuts = data["containsNuts"] as? Bool ?? false
                            newRecipe.containsSeafood = data["containsSeafood"] as? Bool ?? false
                            newRecipe.containsSoy = data["containsSoy"] as? Bool ?? false
                            newRecipe.containsEggs = data["containsEggs"] as? Bool ?? false
                            newRecipe.containsPeanuts = data["containsPeanuts"] as? Bool ?? false
                            newRecipe.containsTreeNuts = data["containsTreeNuts"] as? Bool ?? false
                            newRecipe.containsWheat = data["containsWheat"] as? Bool ?? false
                            newRecipe.containsFish = data["containsFish"] as? Bool ?? false
                            newRecipe.containsShellfish = data["containsShellfish"] as? Bool ?? false
                            newRecipe.containsSesame = data["containsSesame"] as? Bool ?? false
                            newRecipe.containsSulfites = data["containsSulfites"] as? Bool ?? false
                            newRecipe.containsMustard = data["containsMustard"] as? Bool ?? false
                            newRecipe.containsCelery = data["containsCelery"] as? Bool ?? false
                            newRecipe.isVegan = data["isVegan"] as? Bool ?? false
                            newRecipe.isVegetarian = data["isVegetarian"] as? Bool ?? false
                            
                            try context.save()
                        }
                    } catch {
                        print("Failed to fetch or save recipe: \(error)")
                    }
                }
            }
        }
    }
    
    func printAllRecipes(context: NSManagedObjectContext) {
        let fetchRequest: NSFetchRequest = DishEntity.fetchRequest();do {
            let recipes = try context.fetch(fetchRequest)
            for recipe in recipes {
                print("Recipe ID: \(recipe.id?.uuidString ?? "Unknown ID"), Title: \(recipe.title ?? "Unknown Title")")
            }
        } catch {
            print("Failed to fetch recipes: \(error)")
        }
    }
}
