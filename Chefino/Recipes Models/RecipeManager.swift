//
//  RecipeManager.swift
//  Chefino
//
//  Created by Mehmet Akkavak on 10.06.2024.
import UIKit
import CoreData
import FirebaseFirestore

struct RecipeManager {
    static let shared = RecipeManager()
    private let viewContext = PersistenceController.shared.container.viewContext
    private let firestore = Firestore.firestore()
    
    func addRecipe(recipeData: RecipeData) {
        let newRecipe = DishEntity(context: viewContext)
        newRecipe.id = UUID()
        newRecipe.title = recipeData.title
        newRecipe.ingredients = recipeData.ingredients
        newRecipe.timestamp = Date()
        newRecipe.category = recipeData.category
        newRecipe.tags = recipeData.tags
        newRecipe.isFavorite = false // Varsayılan olarak favori değil
        
        newRecipe.containsGluten = recipeData.containsGluten
        newRecipe.containsDairy = recipeData.containsDairy
        newRecipe.containsNuts = recipeData.containsNuts
        newRecipe.containsSeafood = recipeData.containsSeafood
        newRecipe.containsSoy = recipeData.containsSoy
        newRecipe.containsEggs = recipeData.containsEggs
        newRecipe.containsFish = recipeData.containsFish
        newRecipe.containsPeanuts = recipeData.containsPeanuts
        newRecipe.containsShellfish = recipeData.containsShellfish
        newRecipe.containsTreeNuts = recipeData.containsTreeNuts
        newRecipe.containsWheat = recipeData.containsWheat
        newRecipe.containsSesame = recipeData.containsSesame
        newRecipe.containsSulfites = recipeData.containsSulfites
        newRecipe.containsMustard = recipeData.containsMustard
        newRecipe.containsCelery = recipeData.containsCelery
        
        if let photo0 = UIImage(named: recipeData.photoNames[0])?.jpegData(compressionQuality: 1.0) {
            newRecipe.photo = photo0
        }
        if let photo1 = UIImage(named: recipeData.photoNames[1])?.jpegData(compressionQuality: 1.0) {
            newRecipe.photo1 = photo1
        }
        if let photo2 = UIImage(named: recipeData.photoNames[2])?.jpegData(compressionQuality: 1.0) {
            newRecipe.photo2 = photo2
        }
        if let photo3 = UIImage(named: recipeData.photoNames[3])?.jpegData(compressionQuality: 1.0) {
            newRecipe.photo3 = photo3
        }
        
        newRecipe.description1 = recipeData.descriptions[0]
        newRecipe.description2 = recipeData.descriptions[1]
        newRecipe.description3 = recipeData.descriptions[2]
        newRecipe.description4 = recipeData.descriptions[3]
        
        do {
            try viewContext.save()
            print("Recipe saved: \(newRecipe.title ?? "Unknown Title") in category \(newRecipe.category ?? "Unknown Category")")
            
            // Firestore'a kaydet
            saveRecipeToFirestore(recipeData: recipeData)
            
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    private func saveRecipeToFirestore(recipeData: RecipeData) {
        let recipeDict: [String: Any] = [
            "title": recipeData.title,
            "ingredients": recipeData.ingredients,
            "timestamp": Date(),
            "category": recipeData.category,
            "tags": recipeData.tags,
            "containsGluten": recipeData.containsGluten,
            "containsDairy": recipeData.containsDairy,
            "containsNuts": recipeData.containsNuts,
            "containsSeafood": recipeData.containsSeafood,
            "containsSoy": recipeData.containsSoy,
            "containsEggs": recipeData.containsEggs,
            "containsFish": recipeData.containsFish,
            "containsPeanuts": recipeData.containsPeanuts,
            "containsShellfish": recipeData.containsShellfish,
            "containsTreeNuts": recipeData.containsTreeNuts,
            "containsWheat": recipeData.containsWheat,
            "containsSesame": recipeData.containsSesame,
            "containsSulfites": recipeData.containsSulfites,
            "containsMustard": recipeData.containsMustard,
            "containsCelery": recipeData.containsCelery,
            "descriptions": recipeData.descriptions,
            "photoNames": recipeData.photoNames
        ]
        
        firestore.collection("recipes").addDocument(data: recipeDict) { error in
            if let error = error {
                print("Error adding document: \(error)")
            } else {
                print("Document added successfully!")
            }
        }
    }
    
    func addSampleRecipes() {
        let sampleRecipes = [
            RecipeData(
                title: "Éclair",
                ingredients: "Choux pastry, Chocolate, Cream",
                category: "Patisserie",
                photoNames: ["eclair", "eclair1", "eclair2", "eclair3"],
                descriptions: ["Make choux pastry", "Fill with cream", "Dip in chocolate", "Serve"],
                tags: ["Dessert", "Pastry"],
                containsGluten: true,
                containsDairy: true,
                containsNuts: false,
                containsSeafood: false,
                containsSoy: false,
                containsEggs: true,
                containsFish: false,
                containsPeanuts: false,
                containsShellfish: false,
                containsTreeNuts: false,
                containsWheat: true,
                containsSesame: false,
                containsSulfites: false,
                containsMustard: false,
                containsCelery: false
            ),
            RecipeData(
                title: "Baguette",
                ingredients: "Flour, Water, Yeast",
                category: "Bakery",
                photoNames: ["baguette", "baguette1", "baguette2", "baguette3"],
                descriptions: ["Mix dough", "Shape dough", "Proof dough", "Bake"],
                tags: ["Bread"],
                containsGluten: true,
                containsDairy: false,
                containsNuts: false,
                containsSeafood: false,
                containsSoy: false,
                containsEggs: false,
                containsFish: false,
                containsPeanuts: false,
                containsShellfish: false,
                containsTreeNuts: false,
                containsWheat: true,
                containsSesame: false,
                containsSulfites: false,
                containsMustard: false,
                containsCelery: false
            ),
            RecipeData(
                title: "Béchamel",
                ingredients: "Milk, Butter, Flour",
                category: "Saucier",
                photoNames: ["bechamel", "bechamel1", "bechamel2", "bechamel3"],
                descriptions: ["Melt the butter", "Add flour", "Whisk in milk", "Simmer"],
                tags: ["Sauce"],
                containsGluten: true,
                containsDairy: true,
                containsNuts: false,
                containsSeafood: false,
                containsSoy: false,
                containsEggs: false,
                containsFish: false,
                containsPeanuts: false,
                containsShellfish: false,
                containsTreeNuts: false,
                containsWheat: true,
                containsSesame: false,
                containsSulfites: false,
                containsMustard: false,
                containsCelery: false
            ),
            RecipeData(
                title: "Caesar Salad",
                ingredients: "Romaine lettuce, Caesar dressing, Croutons",
                category: "Garde Manger",
                photoNames: ["caesar", "caesar1", "caesar2", "caesar3"],
                descriptions: ["Chop lettuce", "Add dressing", "Add croutons", "Toss"],
                tags: ["Salad"],
                containsGluten: true,
                containsDairy: true,
                containsNuts: false,
                containsSeafood: false,
                containsSoy: false,
                containsEggs: true,
                containsFish: true,
                containsPeanuts: false,
                containsShellfish: false,
                containsTreeNuts: false,
                containsWheat: true,
                containsSesame: false,
                containsSulfites: false,
                containsMustard: false,
                containsCelery: false
            ),
            RecipeData(
                title: "Ratatouille",
                ingredients: "Zucchini, Eggplant, Tomato",
                category: "Entrimetrier",
                photoNames: ["ratatouille", "ratatouille1", "ratatouille2", "ratatouille3"],
                descriptions: ["Chop vegetables", "Layer vegetables", "Add sauce", "Bake"],
                tags: ["Vegetable"],
                containsGluten: false,
                containsDairy: false,
                containsNuts: false,
                containsSeafood: false,
                containsSoy: false,
                containsEggs: false,
                containsFish: false,
                containsPeanuts: false,
                containsShellfish: false,
                containsTreeNuts: false,
                containsWheat: false,
                containsSesame: false,
                containsSulfites: false,
                containsMustard: false,
                containsCelery: false
            )
        ]
        sampleRecipes.forEach { addRecipe(recipeData: $0) }
    }
    
    // Tarifin favori durumunu değiştirme fonksiyonu
    func toggleFavoriteStatus(for recipe: DishEntity) {
        recipe.isFavorite.toggle()
        
        do {
            try viewContext.save()
            print("Favorite status updated.")
        } catch {
            print("Failed to update favorite status: (error)")
        }
    }
    // Favori tarifleri yükleme fonksiyonu
    func loadFavoriteRecipes() -> [DishEntity] {
        let fetchRequest: NSFetchRequest<DishEntity> = DishEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "isFavorite == %@", NSNumber(value: true))
        
        do {
            let favoriteRecipes = try viewContext.fetch(fetchRequest)
            return favoriteRecipes
        } catch {
            print("Failed to fetch favorite recipes: \(error)")
            return []
        }
    }
}
