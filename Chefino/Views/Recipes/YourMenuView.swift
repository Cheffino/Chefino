//
//  YourMenuView.swift
//  Chefino
//
//  Created by Mehmet Akkavak on 10.06.2024.
import SwiftUI
import CoreData
import PDFKit
import LinkPresentation

struct YourMenuView: View {
    @FetchRequest(
        entity: DishEntity.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \DishEntity.timestamp, ascending: true)]
    ) var recipes: FetchedResults<DishEntity>
    
    @EnvironmentObject var recipeSelectionManager: RecipeSelectionManager
    
    @State private var showShareSheet = false
    @State private var pdfData: Data?
    
    var body: some View {
        NavigationView {
            ZStack {
                Image("background1")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                    .clipped()
                    .edgesIgnoringSafeArea(.all)
                    .offset(x: -5)
                
                VStack(spacing: 70) {
                    Spacer()
                    
                    VStack(spacing: 60) {
                        categoryButtonWithIngredients(recipe: recipeSelectionManager.selectedAmuseBouche, fallbackTitle: "Amuse Bouche", destination: GardeMangerRecipesView())
                        categoryButtonWithIngredients(recipe: recipeSelectionManager.selectedSaladDressing, fallbackTitle: " Cold Starter ", destination: GardeMangerRecipesView())
                        categoryButtonWithIngredients(recipe: recipeSelectionManager.selectedSoupCrouton, fallbackTitle: "Soup", destination: EntrimetrierRecipesView())
                        categoryButtonWithIngredients(recipe: recipeSelectionManager.selectedHotStarterSauce, fallbackTitle: " Hot Starter ", destination: EntrimetrierRecipesView())
                        categoryButtonWithIngredients(recipe: recipeSelectionManager.selectedMainCourse, fallbackTitle: "Main Course", destination: SaucierRecipesView())
                        categoryButtonWithIngredients(recipe: recipeSelectionManager.selectedDessert, fallbackTitle: "Dessert", destination: PatisserieRecipesView())
                    }
                    
                    Spacer()
                }
                
                VStack {
                    Spacer()
                    HStack {
                        Menu {
                            Button(action: {
                                pdfData = exportMenuToPDF()
                                showShareSheet = true
                            }) {
                                Text("Menu")
                            }
                            
                            Button(action: {
                                pdfData = exportRecipesToPDF()
                                showShareSheet = true
                            }) {
                                Text("Recipes")
                            }
                            
                            Button(action: {
                                pdfData = exportShoppingListToPDF()
                                showShareSheet = true
                            }) {
                                Text("Shopping List")
                            }
                            
                            Button(action: {
                                pdfData = exportMiseEnPlaceListToPDF()
                                showShareSheet = true
                            }) {
                                Text("Mise en Place List")
                            }
                        } label: {
                            VStack {
                                Image(systemName: "square.and.arrow.down.on.square.fill")
                                    .imageScale(.large)
                                Text("PDF")
                                    .font(.caption)
                            }
                        }
                        .padding()
                        
                        Spacer()
                    }
                }
            }
            .navigationBarTitle("", displayMode: .inline)
            .sheet(isPresented: $showShareSheet) {
                if let pdfData = pdfData {
                    ShareSheet(activityItems: [pdfData])
                }
            }
        }
    }
    
    func categoryButtonWithIngredients(recipe: DishEntity?, fallbackTitle: String, destination: some View) -> AnyView {
        if let recipe = recipe {
            return AnyView(NavigationLink(destination: DetailView(recipe: recipe)) {
                VStack {
                    Text(recipe.title ?? fallbackTitle)
                        .foregroundColor(.brown)
                        .font(.system(size: 24, weight: .bold))
                    Text(getRecipeIngredients(recipe: recipe, count: 3) ?? "No Ingredients")
                        .foregroundColor(.red)
                        .font(.system(size: 18, weight: .regular))
                }
            })
        } else {
            return AnyView(NavigationLink(destination: destination.environmentObject(recipeSelectionManager)) {
                VStack {
                    Text(fallbackTitle)
                        .foregroundColor(.brown)
                        .font(.system(size: 24, weight: .bold))
                }
            })
        }
    }
    
    func getRecipeIngredients(recipe: DishEntity?, count: Int) -> String? {
        guard let recipe = recipe, let ingredients = recipe.ingredients?.components(separatedBy: ", ") else { return nil }
        return ingredients.prefix(count).joined(separator: ", ")
    }
    
    func exportMenuToPDF() -> Data? {
        let pdfMetaData = [
            kCGPDFContextCreator: "Culinario",
            kCGPDFContextAuthor: "Mehmet Akkavak",
            kCGPDFContextTitle: "Menu"
        ]
        let format = UIGraphicsPDFRendererFormat()
        format.documentInfo = pdfMetaData as [String: Any]
        
        let pageWidth = 8.5 * 72.0
        let pageHeight = 11 * 72.0
        let pageRect = CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight)
        
        let renderer = UIGraphicsPDFRenderer(bounds: pageRect, format: format)
        return renderer.pdfData { (context) in
            context.beginPage()
            
            // Arka Plan Resmi
            if let backgroundImage = UIImage(named: "MenuBackground") {
                context.cgContext.draw(backgroundImage.cgImage!, in: pageRect)
            }
            
            var yPosition = 20.0
            
            let titleAttributes = [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 36, weight: .bold),
                NSAttributedString.Key.foregroundColor: UIColor.black
            ]
            var text = "Menu"
            text.draw(at: CGPoint(x: 20, y: yPosition), withAttributes: titleAttributes)
            yPosition += 50
            
            let itemTitleAttributes = [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 24, weight: .bold),
                NSAttributedString.Key.foregroundColor: UIColor.brown
            ]
            let itemAttributes = [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18, weight: .regular),
                NSAttributedString.Key.foregroundColor: UIColor.red
            ]
            
            let menuItems = [
                recipeSelectionManager.selectedAmuseBouche,
                recipeSelectionManager.selectedSaladDressing,
                recipeSelectionManager.selectedSoupCrouton,
                recipeSelectionManager.selectedHotStarterSauce,
                recipeSelectionManager.selectedMainCourse,
                recipeSelectionManager.selectedDessert
            ]
            
            for item in menuItems {
                if let recipe = item {
                    text = recipe.title ?? "No Title"
                    text.draw(at: CGPoint(x: 20, y: yPosition), withAttributes: itemTitleAttributes)
                    yPosition += 30
                    text = getRecipeIngredients(recipe: recipe, count: 3) ?? "No Ingredients"
                    text.draw(at: CGPoint(x: 20, y: yPosition), withAttributes: itemAttributes)
                    yPosition += 30
                }
            }
        }
    }
    
    func exportRecipesToPDF() -> Data? {
        let pdfMetaData = [
            kCGPDFContextCreator: "Culinario",
            kCGPDFContextAuthor: "Mehmet Akkavak",
            kCGPDFContextTitle: "Recipes"
        ]
        let format = UIGraphicsPDFRendererFormat()
        format.documentInfo = pdfMetaData as [String: Any]
        
        let pageWidth = 8.5 * 72.0
        let pageHeight = 11 * 72.0
        let pageRect = CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight)
        
        let renderer = UIGraphicsPDFRenderer(bounds: pageRect, format: format)
        return renderer.pdfData { (context) in
            context.beginPage()
            // Arka Plan Resmi
            if let backgroundImage = UIImage(named: "RecipesBackground") {
                context.cgContext.draw(backgroundImage.cgImage!, in: pageRect)
            }
            
            var yPosition = 20.0
            
            let titleAttributes = [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 36, weight: .bold),
                NSAttributedString.Key.foregroundColor: UIColor.black
            ]
            var text = "Recipes"
            text.draw(at: CGPoint(x: 20, y: yPosition), withAttributes: titleAttributes)
            yPosition += 50
            
            let itemTitleAttributes = [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 24, weight: .bold),
                NSAttributedString.Key.foregroundColor: UIColor.brown
            ]
            let itemAttributes = [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18, weight: .regular),
                NSAttributedString.Key.foregroundColor: UIColor.red
            ]
            
            for recipe in recipes {
                text = recipe.title ?? "No Title"
                text.draw(at: CGPoint(x: 20, y: yPosition), withAttributes: itemTitleAttributes)
                yPosition += 30
                text = recipe.ingredients ?? "No Ingredients"
                text.draw(at: CGPoint(x: 20, y: yPosition), withAttributes: itemAttributes)
                yPosition += 30
                
                for index in 0..<4 {
                    if let descriptionText = getDescriptionText(for: recipe, index: index) {
                        text = descriptionText
                        text.draw(at: CGPoint(x: 20, y: yPosition), withAttributes: itemAttributes)
                        yPosition += 30
                    }
                }
                context.beginPage()
                yPosition = 20.0
            }
        }
    }
    
    func exportShoppingListToPDF() -> Data? {
        let pdfMetaData = [
            kCGPDFContextCreator: "Culinario",
            kCGPDFContextAuthor: "Mehmet Akkavak",
            kCGPDFContextTitle: "Shoping List"
        ]
        let format = UIGraphicsPDFRendererFormat()
        format.documentInfo = pdfMetaData as [String: Any]
        let pageWidth = 8.5 * 72.0
        let pageHeight = 11 * 72.0
        let pageRect = CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight)
        
        let renderer = UIGraphicsPDFRenderer(bounds: pageRect, format: format)
        return renderer.pdfData { (context) in
            context.beginPage()
            
            // Arka Plan Resmi
            if let backgroundImage = UIImage(named: "ShoppingListBackground") {
                context.cgContext.draw(backgroundImage.cgImage!, in: pageRect)
            }
            
            var yPosition = 20.0
            
            let titleAttributes = [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 36, weight: .bold),
                NSAttributedString.Key.foregroundColor: UIColor.black
            ]
            var text = "Shopping List"
            text.draw(at: CGPoint(x: 20, y: yPosition), withAttributes: titleAttributes)
            yPosition += 50
            
            let itemAttributes = [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18, weight: .regular),
                NSAttributedString.Key.foregroundColor: UIColor.red
            ]
            
            let selectedRecipes = [
                recipeSelectionManager.selectedAmuseBouche,
                recipeSelectionManager.selectedSaladDressing,
                recipeSelectionManager.selectedSoupCrouton,
                recipeSelectionManager.selectedHotStarterSauce,
                recipeSelectionManager.selectedMainCourse,
                recipeSelectionManager.selectedDessert
            ]
            
            var ingredientsList = [String: Int]()
            
            for recipe in selectedRecipes {
                guard let ingredients = recipe?.ingredients?.components(separatedBy: ", ") else { continue }
                for ingredient in ingredients {
                    if let count = ingredientsList[ingredient] {
                        ingredientsList[ingredient] = count + 1
                    } else {
                        ingredientsList[ingredient] = 1
                    }
                }
            }
            
            for (ingredient, count) in ingredientsList {
                text = "\(ingredient) x \(count)"
                text.draw(at: CGPoint(x: 20, y: yPosition), withAttributes: itemAttributes)
                yPosition += 30
            }
        }
    }
    
    func exportMiseEnPlaceListToPDF() -> Data? {
        let pdfMetaData = [
            kCGPDFContextCreator: "Culinario",
            kCGPDFContextAuthor: "Mehmet Akkavak",
            kCGPDFContextTitle: "Mise en Place List"
        ]
        let format = UIGraphicsPDFRendererFormat()
        format.documentInfo = pdfMetaData as [String: Any]
        
        let pageWidth = 8.5 * 72.0
        let pageHeight = 11 * 72.0
        let pageRect = CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight)
        
        let renderer = UIGraphicsPDFRenderer(bounds: pageRect, format: format)
        return renderer.pdfData { (context) in
            context.beginPage()
            
            // Arka Plan Resmi
            if let backgroundImage = UIImage(named: "MiseEnPlaceBackground") {
                context.cgContext.draw(backgroundImage.cgImage!, in: pageRect)
            }
            
            var yPosition = 20.0
            
            let titleAttributes = [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 36, weight: .bold),
                NSAttributedString.Key.foregroundColor: UIColor.black
            ]
            var text = "Mise en Place List"
            text.draw(at: CGPoint(x: 20, y: yPosition), withAttributes: titleAttributes)
            yPosition += 50
            
            let itemAttributes = [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18, weight: .regular),
                NSAttributedString.Key.foregroundColor: UIColor.red
            ]
            
            let selectedRecipes = [
                recipeSelectionManager.selectedAmuseBouche,
                recipeSelectionManager.selectedSaladDressing,
                recipeSelectionManager.selectedSoupCrouton,
                recipeSelectionManager.selectedHotStarterSauce,
                recipeSelectionManager.selectedMainCourse,
                recipeSelectionManager.selectedDessert
            ]
            
            var miseEnPlaceList = [String: Int]()
            
            for recipe in selectedRecipes {
                guard let ingredients = recipe?.ingredients?.components(separatedBy: ", ") else { continue }
                for ingredient in ingredients {
                    if let count = miseEnPlaceList[ingredient] {
                        miseEnPlaceList[ingredient] = count + 1
                    } else {
                        miseEnPlaceList[ingredient] = 1
                    }
                }
            }
            
            for (ingredient, count) in miseEnPlaceList {
                text = "\(ingredient) x \(count)"
                text.draw(at: CGPoint(x: 20, y: yPosition), withAttributes: itemAttributes)
                yPosition += 30
            }
        }
    }
    
    func getDescriptionText(for recipe: DishEntity, index: Int) -> String? {
        switch index {
        case 0:
            return recipe.description1
        case 1:
            return recipe.description2
        case 2:
            return recipe.description3
        case 3:
            return recipe.description4
        default:
            return nil
        }
    }
}
