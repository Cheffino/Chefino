//
//  RecipeData.swift
//  Chefino
//
//  Created by Mehmet Akkavak on 9.06.2024.
import Foundation
import CoreData
import FirebaseFirestore
import FirebaseFirestoreSwift

struct RecipeData {
    let title: String
    let ingredients: String
    let category: String
    let photoNames: [String]
    let descriptions: [String]
    let tags: [String] // Dizi olarak saklanacak
    let containsGluten: Bool
    let containsDairy: Bool
    let containsNuts: Bool
    let containsSeafood: Bool
    let containsSoy: Bool
    let containsEggs: Bool
    let containsFish: Bool
    let containsPeanuts: Bool
    let containsShellfish: Bool
    let containsTreeNuts: Bool
    let containsWheat: Bool
    let containsSesame: Bool
    let containsSulfites: Bool
    let containsMustard: Bool
    let containsCelery: Bool
}

// Patisserie Recipe
let patisserieRecipe = RecipeData(
    title: "Éclair",
    ingredients: "Choux pastry, Chocolate, Cream",
    category: "Patisserie",
    photoNames: ["eclair", "eclair1", "eclair2", "eclair3"],
    descriptions: ["Make choux pastry", "Fill with cream", "Dip in chocolate", "Serve"],
    tags: ["Dessert", "Pastry"], // Örnek etiketler
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
)

// Bakery Recipe
let bakeryRecipe = RecipeData(
    title: "Baguette",
    ingredients: "Flour, Water, Yeast",
    category: "Bakery",
    photoNames: ["baguette", "baguette1", "baguette2", "baguette3"],
    descriptions: ["Mix dough", "Shape dough", "Proof dough", "Bake"],
    tags: ["Bread"], // Örnek etiketler
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
)

// Saucier Recipe
let saucierRecipe = RecipeData(
    title: "Béchamel",
    ingredients: "Milk, Butter, Flour",
    category: "Saucier",
    photoNames: ["bechamel", "bechamel1", "bechamel2", "bechamel3"],
    descriptions: ["Melt the butter", "Add flour", "Whisk in milk", "Simmer"],
    tags: ["Sauce"], // Örnek etiketler
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
)

// Garde Manger Recipe
let gardeMangerRecipe = RecipeData(
    title: "Caesar Salad",
    ingredients: "Romaine lettuce, Caesar dressing, Croutons",
    category: "Garde Manger",
    photoNames: ["caesar", "caesar1", "caesar2", "caesar3"],
    descriptions: ["Chop lettuce", "Add dressing", "Add croutons", "Toss"],
    tags: ["Salad"], // Örnek etiketler
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
)

// Entrimetrier Recipe
let entrimetrierRecipe = RecipeData(
    title: "Ratatouille",
    ingredients: "Zucchini, Eggplant, Tomato",
    category: "Entrimetrier",
    photoNames: ["ratatouille", "ratatouille1", "ratatouille2", "ratatouille3"],
    descriptions: ["Chop vegetables", "Layer vegetables", "Add sauce", "Bake"],
    tags: ["Vegetable"], // Örnek etiketler
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
