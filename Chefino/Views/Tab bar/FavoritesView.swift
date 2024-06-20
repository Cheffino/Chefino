//
//  FavoritesView.swift
//  Chefino
//
//  Created by Mehmet Akkavak on 8.06.2024.
//
import SwiftUI
import CoreData
import Lottie

struct FavoritesView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        entity: DishEntity.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \DishEntity.timestamp, ascending: true)],
        predicate: NSPredicate(format: "isFavorite == %@", NSNumber(value: true))
    ) var favoriteRecipes: FetchedResults<DishEntity>

    var body: some View {
        NavigationView {
            Group {
                if favoriteRecipes.isEmpty {
                    VStack {
                        LottieView(url: URL(string: "https://lottie.host/ca12b392-a51d-4ad8-b93c-b45682b7ef12/Vwa4m9AAwO.json")!)
                            .frame(width: 400, height: 400)
                            .padding()
                        Text("You have no favorite recipes yet.")
                            .font(.headline)
                            .padding()
                    }
                } else {
                    List {
                        ForEach(favoriteRecipes) { recipe in
                            NavigationLink(destination: DetailView(recipe: recipe)) {
                                VStack(alignment: .leading) {
                                    Text(recipe.title ?? "Unknown Title")
                                        .font(.headline)
                                    Text(recipe.ingredients ?? "No Ingredients")
                                        .font(.subheadline)
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Favorite Recipes")
        }
    }
}

struct FavoritesView_Previews: PreviewProvider {
    static var previews: some View {
        FavoritesView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
