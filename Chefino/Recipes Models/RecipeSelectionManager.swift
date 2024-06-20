//
//  RecipeSelectionManager.swift
//  Chefino
//
//  Created by Mehmet Akkavak on 11.06.2024.
//

import SwiftUI
import CoreData

@available(iOS 13.0, *)
class RecipeSelectionManager: ObservableObject {
    @Published var selectedAmuseBouche: DishEntity?
    @Published var selectedSaladDressing: DishEntity?
    @Published var selectedSoupCrouton: DishEntity?
    @Published var selectedHotStarterSauce: DishEntity?
    @Published var selectedMainCourse: DishEntity?
    @Published var selectedSauce: DishEntity?
    @Published var selectedDessert: DishEntity?
    
    @Published var favoriteRecipes: [DishEntity] = []
    
    func addFavorite(recipe: DishEntity) {
        if !favoriteRecipes.contains(where: { $0.id == recipe.id }) {
            favoriteRecipes.append(recipe)
        }
    }
    
    func removeFavorite(recipe: DishEntity) {
        favoriteRecipes.removeAll { $0.id == recipe.id }
    }
    
    func isFavorite(recipe: DishEntity) -> Bool {
        return favoriteRecipes.contains(where: { $0.id == recipe.id })
    }
}
