//
//  BatchProcessing.swift
//  Chefino
//
//  Created by Mehmet Akkavak on 10.06.2024.
//
import Foundation
import CoreData

struct BatchProcessing {
    static func addMultipleRecipes(context: NSManagedObjectContext, recipes: [RecipeModel]) {
        context.perform {
            for recipe in recipes {
                DataHelpers.addRecipe(
                    context: context,
                    id: recipe.id, // id parametresini ekleyelim
                    title: recipe.title,
                    ingredients: recipe.ingredients,
                    category: recipe.category,
                    descriptions: recipe.descriptions,
                    imageDatas: recipe.imageDatas,
                    photoNames: recipe.photoNames,
                    containsGluten: recipe.containsGluten,
                    containsDairy: recipe.containsDairy,
                    containsNuts: recipe.containsNuts,
                    containsSeafood: recipe.containsSeafood,
                    containsSoy: recipe.containsSoy,
                    containsEggs: recipe.containsEggs,
                    containsPeanuts: recipe.containsPeanuts,
                    containsTreeNuts: recipe.containsTreeNuts,
                    containsWheat: recipe.containsWheat,
                    containsFish: recipe.containsFish,
                    containsShellfish: recipe.containsShellfish,
                    containsSesame: recipe.containsSesame,
                    containsSulfites: recipe.containsSulfites,
                    containsMustard: recipe.containsMustard
                )
            }
            do {
                try context.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}
