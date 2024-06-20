//
//  ContentView.swift
//  Chefino
//
//  Created by Mehmet Akkavak on 8.06.2024.
//
import SwiftUI
import CoreData
import FirebaseFirestore

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State private var showSplashScreen: Bool = true

    var body: some View {
        Group {
            if showSplashScreen {
                SplashScreen()
            } else {
                TabView {
                    HomeView()
                        .tabItem {
                            Image(systemName: "house")
                            Text("Home")
                        }
                        .environment(\.managedObjectContext, viewContext)

                    FavoritesView()
                        .tabItem {
                            Image(systemName: "star.square")
                            Text("Favorites")
                        }
                        .environment(\.managedObjectContext, viewContext)

                    SupportView()
                        .tabItem {
                            Image(systemName: "plus.bubble")
                            Text("Support")
                        }
                        .environment(\.managedObjectContext, viewContext)
                }
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                withAnimation {
                    showSplashScreen = false
                }
            }
            loadRecipesFromFirestore(context: viewContext)
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
                    let newRecipe = DishEntity(context: context)
                    newRecipe.id = UUID(uuidString: data["id"] as? String ?? "")
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
                    
                    do {
                        try context.save()
                    } catch {
                        print("Failed to save recipe: \(error)")
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
