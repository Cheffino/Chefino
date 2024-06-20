//
//  DataValidation.swift
//  Chefino
//
//  Created by Mehmet Akkavak on 10.06.2024.
//

import Foundation
struct DataValidation {
    static func validateRecipe(title: String, ingredients: String, category: String, photoNames: [String], descriptions: [String]) -> Bool {
        if title.isEmpty || ingredients.isEmpty || category.isEmpty || photoNames.isEmpty || descriptions.isEmpty {
            return false
        }
        return true
    }
}
