//
//  RecipeModel.swift
//  Chefino
//
//  Created by Mehmet Akkavak on 10.06.2024.
//
import Foundation

struct RecipeModel {
    let id: UUID // ID alanını ekleyin
    let title: String
    let ingredients: String
    let category: String
    let descriptions: [String]
    let imageDatas: [Data?]
    let photoNames: [String]
    let containsGluten: Bool
    let containsDairy: Bool
    let containsNuts: Bool
    let containsSeafood: Bool
    let containsSoy: Bool
    let containsEggs: Bool
    let containsPeanuts: Bool
    let containsTreeNuts: Bool
    let containsWheat: Bool
    let containsFish: Bool
    let containsShellfish: Bool
    let containsSesame: Bool
    let containsSulfites: Bool
    let containsMustard: Bool
}
