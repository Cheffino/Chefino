//
//  RecipeFormView.swift
//  Chefino
//
//  Created by Mehmet Akkavak on 10.06.2024.
import SwiftUI
import CoreData
import FirebaseFirestore
import FirebaseFirestoreSwift

struct RecipeIngredient: Identifiable {
    let id = UUID()
    var name: String
    var amount: Double
    var unit: String
}

struct RecipeFormView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) private var presentationMode
    
    @State var recipe: DishEntity?
    @State private var title = ""
    @State private var ingredients = [RecipeIngredient(name: "", amount: 0, unit: "grams")]
    @State private var selectedCategory = "Entrimetrier"
    @State private var descriptions = ["", "", "", ""]
    @State private var showImagePicker = [false, false, false, false]
    @State private var selectedImageData: [Data?] = [nil, nil, nil, nil]
    
    @State private var containsGluten = false
    @State private var containsDairy = false
    @State private var containsNuts = false
    @State private var containsSeafood = false
    @State private var containsSoy = false
    @State private var containsEggs = false
    @State private var containsPeanuts = false
    @State private var containsTreeNuts = false
    @State private var containsWheat = false
    @State private var containsFish = false
    @State private var containsShellfish = false
    @State private var containsSesame = false
    @State private var containsSulfites = false
    @State private var containsMustard = false
    @State private var containsCelery = false
    
    @State private var isVegan = false
    @State private var isVegetarian = false
    
    let categories = ["Entrimetrier", "Patisserie", "Saucier", "Garde Manger", "Bakery"]
    let units = ["grams", "ml", "cups", "pieces", "tablespoons", "teaspoons"]
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Recipe Details")) {
                    TextField("Title", text: $title)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                    
                    Picker("Category", selection: $selectedCategory) {
                        ForEach(categories, id: \.self) { category in
                            Text(category)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                Section(header: Text("Ingredients")) {
                    ForEach(ingredients.indices, id: \.self) { index in
                        HStack {
                            TextField("Ingredient", text: $ingredients[index].name)
                            TextField("Quantity", value: $ingredients[index].amount, formatter: NumberFormatter())
                                .keyboardType(.decimalPad)
                            Picker("Unit", selection: $ingredients[index].unit) {
                                ForEach(units, id: \.self) {
                                    Text($0)
                                }
                            }
                            .pickerStyle(MenuPickerStyle())
                        }
                    }
                    Button(action: {
                        ingredients.append(RecipeIngredient(name: "", amount: 0, unit: units[0]))
                    }) {
                        Label("Add Ingredient", systemImage: "plus.circle.fill")
                            .foregroundColor(.blue)
                    }
                }
                
                Section(header: Text("Descriptions & Photos")) {
                    ForEach(0..<descriptions.count, id: \.self) { index in
                        VStack(alignment: .leading, spacing: 8) {
                            TextField("Description \(index + 1)", text: $descriptions[index])
                            
                            if let imageData = selectedImageData[index], let uiImage = UIImage(data: imageData) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(maxWidth: .infinity)
                                    .cornerRadius(8)
                            }
                            
                            Button(action: {
                                showImagePicker[index] = true
                            }) {
                                Label("Select Photo", systemImage: "photo.fill")
                                    .foregroundColor(.blue)
                            }
                            .sheet(isPresented: $showImagePicker[index]) {
                                ImagePicker(imageData: $selectedImageData[index])
                            }
                        }
                    }
                }
                
                Section(header: Text("Allergen Information")) {
                    Toggle("Contains Gluten", isOn: $containsGluten)
                        .toggleStyle(ButtonToggleStyle())
                    Toggle("Contains Dairy", isOn: $containsDairy)
                        .toggleStyle(ButtonToggleStyle())
                    Toggle("Contains Nuts", isOn: $containsNuts)
                        .toggleStyle(ButtonToggleStyle())
                    Toggle("Contains Seafood", isOn: $containsSeafood)
                        .toggleStyle(ButtonToggleStyle())
                    Toggle("Contains Soy", isOn: $containsSoy)
                        .toggleStyle(ButtonToggleStyle())
                    Toggle("Contains Eggs", isOn: $containsEggs)
                        .toggleStyle(ButtonToggleStyle())
                    Toggle("Contains Peanuts", isOn: $containsPeanuts)
                        .toggleStyle(ButtonToggleStyle())
                    Toggle("Contains Tree Nuts", isOn: $containsTreeNuts)
                        .toggleStyle(ButtonToggleStyle())
                    Toggle("Contains Wheat", isOn: $containsWheat)
                        .toggleStyle(ButtonToggleStyle())
                    Toggle("Contains Fish", isOn: $containsFish)
                        .toggleStyle(ButtonToggleStyle())
                    Toggle("Contains Shellfish", isOn: $containsShellfish)
                        .toggleStyle(ButtonToggleStyle())
                    Toggle("Contains Sesame", isOn: $containsSesame)
                        .toggleStyle(ButtonToggleStyle())
                    Toggle("Contains Sulfites", isOn: $containsSulfites)
                        .toggleStyle(ButtonToggleStyle())
                    Toggle("Contains Mustard", isOn: $containsMustard)
                        .toggleStyle(ButtonToggleStyle())
                    Toggle("Contains Celery", isOn: $containsCelery)
                        .toggleStyle(ButtonToggleStyle())
                }
                
                Section(header: Text("Dietary Preferences")) {
                    Toggle("Vegan", isOn: $isVegan)
                        .toggleStyle(ButtonToggleStyle())
                    Toggle("Vegetarian", isOn: $isVegetarian)
                        .toggleStyle(ButtonToggleStyle())
                }
            }
            .navigationBarTitle("Add New Recipe", displayMode: .inline)
            .navigationBarItems(trailing: Button("Save") {
                saveRecipe()
            })
            .onAppear {
                if let recipe = recipe {
                    title = recipe.title ?? ""
                    ingredients = recipe.ingredients?.split(separator: ",").map { ingredient in
                        let parts = ingredient.split(separator: " ")
                        let amount = Double(parts[0]) ?? 0.0
                        let unit = String(parts[1])
                        let name = parts[2...].joined(separator: " ")
                        return RecipeIngredient(name: name, amount: amount, unit: unit)
                    } ?? []
                    selectedCategory = recipe.category ?? "Entrimetrier"
                    descriptions[0] = recipe.description1 ?? ""
                    descriptions[1] = recipe.description2 ?? ""
                    descriptions[2] = recipe.description3 ?? ""
                    descriptions[3] = recipe.description4 ?? ""
                    selectedImageData[0] = recipe.photo
                    selectedImageData[1] = recipe.photo1
                    selectedImageData[2] = recipe.photo2
                    selectedImageData[3] = recipe.photo3
                    containsGluten = recipe.containsGluten
                    containsDairy = recipe.containsDairy
                    containsNuts = recipe.containsNuts
                    containsSeafood = recipe.containsSeafood
                    containsSoy = recipe.containsSoy
                    containsEggs = recipe.containsEggs
                    containsPeanuts = recipe.containsPeanuts
                    containsTreeNuts = recipe.containsTreeNuts
                    containsWheat = recipe.containsWheat
                    containsFish = recipe.containsFish
                    containsShellfish = recipe.containsShellfish
                    containsSesame = recipe.containsSesame
                    containsSulfites = recipe.containsSulfites
                    containsMustard = recipe.containsMustard
                    containsCelery = recipe.containsCelery
                    isVegan = recipe.isVegan
                    isVegetarian = recipe.isVegetarian
                }
            }
        }
    }
    
    private func saveRecipe() {
        let newRecipe = recipe ?? DishEntity(context: viewContext)
        
        // UUID kontrolü ve atanması
        newRecipe.id = recipe?.id ?? UUID()
        newRecipe.title = title
        newRecipe.ingredients = ingredients.map { "\($0.amount) \($0.unit) \($0.name)" }.joined(separator: ", ")
        newRecipe.category = selectedCategory
        newRecipe.photo = selectedImageData[0]
        newRecipe.photo1 = selectedImageData[1]
        newRecipe.photo2 = selectedImageData[2]
        newRecipe.photo3 = selectedImageData[3]
        newRecipe.description1 = descriptions[0]
        newRecipe.description2 = descriptions[1]
        newRecipe.description3 = descriptions[2]
        newRecipe.description4 = descriptions[3]
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
        newRecipe.containsCelery = containsCelery
        newRecipe.isVegan = isVegan
        newRecipe.isVegetarian = isVegetarian
        
        // Firestore'a kaydet
        let db = Firestore.firestore()
        let recipeData: [String: Any] = [
            "id": newRecipe.id?.uuidString ?? UUID().uuidString,
            "title": newRecipe.title ?? "",
            "ingredients": newRecipe.ingredients ?? "",
            "category": newRecipe.category ?? "",
            "photo": selectedImageData[0] ?? Data(),
            "photo1": selectedImageData[1] ?? Data(),
            "photo2": selectedImageData[2] ?? Data(),
            "photo3": selectedImageData[3] ?? Data(),
            "description1": newRecipe.description1 ?? "",
            "description2": newRecipe.description2 ?? "",
            "description3": newRecipe.description3 ?? "",
            "description4": newRecipe.description4 ?? "",
            "containsGluten": newRecipe.containsGluten,
            "containsDairy": newRecipe.containsDairy,
            "containsNuts": newRecipe.containsNuts,
            "containsSeafood": newRecipe.containsSeafood,
            "containsSoy": newRecipe.containsSoy,
            "containsEggs": newRecipe.containsEggs,
            "containsPeanuts": newRecipe.containsPeanuts,
            "containsTreeNuts": newRecipe.containsTreeNuts,
            "containsWheat": newRecipe.containsWheat,
            "containsFish": newRecipe.containsFish,
            "containsShellfish": newRecipe.containsShellfish,
            "containsSesame": newRecipe.containsSesame,
            "containsSulfites": newRecipe.containsSulfites,
            "containsMustard": newRecipe.containsMustard,
            "containsCelery": newRecipe.containsCelery,
            "isVegan": newRecipe.isVegan,
            "isVegetarian": newRecipe.isVegetarian
        ]
        
        db.collection("recipes").document(newRecipe.id?.uuidString ?? UUID().uuidString).setData(recipeData) { error in
            if let error = error {
                print("Error adding document: \(error)")
            } else {
                print("Document added with ID: \(newRecipe.id?.uuidString ?? "Unknown ID")")
            }
        }
        
        do {
            try viewContext.save()
            presentationMode.wrappedValue.dismiss()
            navigateToCategory(selectedCategory)
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    private func navigateToCategory(_ category: String) {
        // Kategoriye göre gezinme mantığını implement edin
        // Örneğin:
        // if category == "Entrimetrier" {
        //     // Entrimetrier görünümüne gezin
        // }

        struct ButtonToggleStyle: ToggleStyle {
            func makeBody(configuration: Configuration) -> some View {
                Button(action: {
                    configuration.isOn.toggle()
                }) {
                    HStack {
                        configuration.label
                        Spacer()
                        if configuration.isOn {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                        } else {
                            Image(systemName: "circle")
                                .foregroundColor(.gray)
                        }
                    }
                }
                .padding()
                .background(configuration.isOn ? Color.blue : Color(.systemGray6))
                .foregroundColor(configuration.isOn ? .white : .black)
                .cornerRadius(8)
            }
        }

        struct RecipeFormView_Previews: PreviewProvider {
            static var previews: some View {
                RecipeFormView()
                    .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
            }
        }
        }
    }
