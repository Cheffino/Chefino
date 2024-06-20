//
//  SaucierRecipesView.swift
//  Chefino
//
//  Created by Mehmet Akkavak on 9.06.2024.
import SwiftUI
import Firebase
import CoreData

struct SaucierRecipesView: View {
    @State private var searchText = ""
    @State private var showFilterSheet = false
    @State private var filterOption = FilterOption.none
    @StateObject private var speechRecognizer = SpeechRecognizer()
    @State private var isRecording = false
    @State private var isGridView = true // Başlangıçta grid view
    @State private var isDataLoaded = false // Veri yüklenme durumu

    @FetchRequest(
        entity: DishEntity.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \DishEntity.timestamp, ascending: true)],
        predicate: NSPredicate(format: "category == %@", "Saucier")
    ) var recipes: FetchedResults<DishEntity>

    enum FilterOption: String, CaseIterable {
        case none = "None"
        case alphabetically = "Alphabetically"
        case byDate = "By Date"
        case mostFavorited = "Most Favorited"
    }

    var filteredRecipes: [DishEntity] {
        var filtered: [DishEntity]
        if searchText.isEmpty {
            filtered = Array(recipes)
        } else {
            filtered = recipes.filter { $0.title?.localizedCaseInsensitiveContains(searchText) ?? false }
        }
        return applyFilter(filtered)
    }

    func applyFilter(_ recipes: [DishEntity]) -> [DishEntity] {
        switch filterOption {
        case .none:
            return recipes
        case .alphabetically:
            return recipes.sorted { ($0.title ?? "") < ($1.title ?? "") }
        case .byDate:
            return recipes.sorted { ($0.timestamp ?? Date()) < ($1.timestamp ?? Date()) }
        case .mostFavorited:
            return recipes.sorted { $0.favoriteCount > $1.favoriteCount }
        }
    }

    var body: some View {
        VStack {
            HStack {
                SearchBar(text: $searchText)
                    .padding(.horizontal)

                Button(action: {
                    isGridView.toggle()
                }) {
                    Image(systemName: isGridView ? "list.bullet" : "square.grid.2x2")
                        .foregroundColor(.blue)
                        .imageScale(.large)
                        .padding(.trailing, 10)
                }

                Button(action: {
                    showFilterSheet.toggle()
                }) {
                    Image(systemName: "line.horizontal.3.decrease.circle")
                        .foregroundColor(.blue)
                        .imageScale(.large)
                        .padding(.trailing, 10)
                }
            }

            if isGridView {
                GridView(recipes: filteredRecipes)
            } else {
                ListView(recipes: filteredRecipes)
            }
        }
        .navigationTitle("Saucier Recipes")
        .onAppear {
            if !isDataLoaded {
                fetchRecipesFromFirebase()
                isDataLoaded = true
            }
        }
        .actionSheet(isPresented: $showFilterSheet) {
            ActionSheet(title: Text("Filter Recipes"), message: nil, buttons: FilterOption.allCases.map { option in
                .default(Text(option.rawValue)) {
                    filterOption = option
                }
            } + [.cancel()])
        }
    }

    func fetchRecipesFromFirebase() {
        let db = Firestore.firestore()
        db.collection("recipes").whereField("category", isEqualTo: "Saucier").getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                let context = PersistenceController.shared.container.viewContext
                for document in querySnapshot!.documents {
                    let data = document.data()
                    if let recipe = Recipe(dictionary: data) {
                        // Core Data'ya tarif ekle
                        let newRecipe = DishEntity(context: context)
                        newRecipe.id = UUID()
                        newRecipe.title = recipe.title
                        newRecipe.ingredients = recipe.ingredients
                        newRecipe.timestamp = recipe.timestamp
                        newRecipe.favoriteCount = Int32(recipe.favoriteCount)
                        newRecipe.category = "Saucier"
                    }
                }
                // Değişiklikleri kaydet
                do {
                    try context.save()
                } catch {
                    print("Error saving context: \(error)")
                }
            }
        }
    }
}

struct ListView: View {
    let recipes: [DishEntity]

    var body: some View {
        List {
            ForEach(recipes, id: \.id) { recipe in
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

struct GridView: View {
    let recipes: [DishEntity]
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(recipes, id: \.id) { recipe in
                    NavigationLink(destination: DetailView(recipe: recipe)) {
                        VStack {
                            Text(recipe.title ?? "Unknown Title")
                                .font(.headline)
                            Text(recipe.ingredients ?? "No Ingredients")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(10)
                    }
                }
            }
            .padding()
        }
    }
}


struct SaucierRecipesView_Previews: PreviewProvider {
    static var previews: some View {
        SaucierRecipesView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
