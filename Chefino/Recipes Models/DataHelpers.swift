//
//  DataHelpers.swift
//  Chefino
//
//  Created by Mehmet Akkavak on 10.06.2024.
import Foundation
import CoreData

struct DataHelpers {
    static func addRecipe(
        context: NSManagedObjectContext,
        id: UUID,
        title: String,
        ingredients: String,
        category: String,
        descriptions: [String],
        imageDatas: [Data?],
        photoNames: [String],
        containsGluten: Bool,
        containsDairy: Bool,
        containsNuts: Bool,
        containsSeafood: Bool,
        containsSoy: Bool,
        containsEggs: Bool,
        containsPeanuts: Bool,
        containsTreeNuts: Bool,
        containsWheat: Bool,
        containsFish: Bool,
        containsShellfish: Bool,
        containsSesame: Bool,
        containsSulfites: Bool,
        containsMustard: Bool
    ) {
        let newRecipe = DishEntity(context: context)
        newRecipe.id = id
        newRecipe.title = title
        newRecipe.ingredients = ingredients
        newRecipe.category = category
        newRecipe.timestamp = Date()
        newRecipe.description1 = descriptions.indices.contains(0) ? descriptions[0] : nil
        newRecipe.description2 = descriptions.indices.contains(1) ? descriptions[1] : nil
        newRecipe.description3 = descriptions.indices.contains(2) ? descriptions[2] : nil
        newRecipe.description4 = descriptions.indices.contains(3) ? descriptions[3] : nil
        newRecipe.photo = imageDatas.indices.contains(0) ? imageDatas[0] : nil
        newRecipe.photo1 = imageDatas.indices.contains(1) ? imageDatas[1] : nil
        newRecipe.photo2 = imageDatas.indices.contains(2) ? imageDatas[2] : nil
        newRecipe.photo3 = imageDatas.indices.contains(3) ? imageDatas[3] : nil

        newRecipe.containsGluten = containsGluten
        newRecipe.containsDairy = containsDairy
        newRecipe.containsNuts = containsNuts
        newRecipe.containsSeafood = containsSeafood
        newRecipe.containsSoy = containsSoy
        newRecipe.containsEggs = containsEggs
        newRecipe.containsPeanuts = containsPeanuts
        newRecipe.containsTreeNuts = containsTreeNuts
        newRecipe.containsWheat = containsWheat
        newRecipe.containsFish = containsFish
        newRecipe.containsShellfish = containsShellfish
        newRecipe.containsSesame = containsSesame
        newRecipe.containsSulfites = containsSulfites
        newRecipe.containsMustard = containsMustard

        do {
            try context.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }

    static func addSampleRecipes(context: NSManagedObjectContext) {
        let sampleRecipes = [
            RecipeModel(
                id: UUID(),
                title: "Ratatouille",
                ingredients: "1 pieces Zucchini, 1 pieces Eggplant, 2 pieces Tomato",
                category: "Entrimetrier",
                descriptions: ["Chop vegetables", "Layer vegetables", "Add sauce", "Bake"],
                imageDatas: [nil, nil, nil, nil],
                photoNames: ["ratatouille", "ratatouille1", "ratatouille2", "ratatouille3"],
                containsGluten: false,
                containsDairy: false,
                containsNuts: false,
                containsSeafood: false,
                containsSoy: false,
                containsEggs: false,
                containsPeanuts: false,
                containsTreeNuts: false,
                containsWheat: false,
                containsFish: false,
                containsShellfish: false,
                containsSesame: false,
                containsSulfites: false,
                containsMustard: false
            ),
            RecipeModel(
                id: UUID(),
                title: "Éclair",
                ingredients: "1 batch Choux pastry, 200 grams Chocolate, 300 ml Cream",
                category: "Patisserie",
                descriptions: ["Make choux pastry", "Fill with cream", "Dip in chocolate", "Serve"],
                imageDatas: [nil, nil, nil, nil],
                photoNames: ["eclair", "eclair1", "eclair2", "eclair3"],
                containsGluten: true,
                containsDairy: true,
                containsNuts: false,
                containsSeafood: false,
                containsSoy: false,
                containsEggs: true,
                containsPeanuts: false,
                containsTreeNuts: false,
                containsWheat: true,
                containsFish: false,
                containsShellfish: false,
                containsSesame: false,
                containsSulfites: false,
                containsMustard: false
            )
            // Diğer örnek tarifleri buraya ekleyin
        ]

        for recipeData in sampleRecipes {
            addRecipe(
                context: context,
                id: recipeData.id,
                title: recipeData.title,
                ingredients: recipeData.ingredients,
                category: recipeData.category,
                descriptions: recipeData.descriptions,
                imageDatas: recipeData.imageDatas,
                photoNames: recipeData.photoNames,
                containsGluten: recipeData.containsGluten,
                containsDairy: recipeData.containsDairy,
                containsNuts: recipeData.containsNuts,
                containsSeafood: recipeData.containsSeafood,
                containsSoy: recipeData.containsSoy,
                containsEggs: recipeData.containsEggs,
                containsPeanuts: recipeData.containsPeanuts,
                containsTreeNuts: recipeData.containsTreeNuts,
                containsWheat: recipeData.containsWheat,
                containsFish: recipeData.containsFish,
                containsShellfish: recipeData.containsShellfish,
                containsSesame: recipeData.containsSesame,
                containsSulfites: recipeData.containsSulfites,
                containsMustard: recipeData.containsMustard
            )
        }
    }
}
