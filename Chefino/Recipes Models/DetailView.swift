//
//  DetailView.swift
//  Chefino
//
//  Created by Mehmet Akkavak on 9.06.2024.
import SwiftUI
import PDFKit

struct DetailView: View {
    var recipe: DishEntity
    @EnvironmentObject var recipeSelectionManager: RecipeSelectionManager
    @Environment(\.managedObjectContext) private var viewContext
    @State private var isFavorite = false
    @State private var showShareSheet = false
    @State private var pdfData: Data?
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text(recipe.title ?? "Sample Recipe")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    Spacer()
                    HStack {
                        Button(action: {
                            addToMenu()
                        }) {
                            Image(systemName: "plus.circle")
                                .font(.title)
                                .foregroundColor(.orange)
                        }
                        .padding(.trailing, 10)
                        
                        Button(action: {
                            isFavorite.toggle()
                            recipe.isFavorite = isFavorite
                            saveContext()
                        }) {
                            Image(systemName: isFavorite ? "star.fill" : "star")
                                .font(.title)
                                .foregroundColor(.yellow)
                        }
                    }
                }
                .padding()
                
                Spacer().frame(height: 40) // Title ile Ingredients arasında 1 cm boşluk
                
                Text("Ingredients")
                    .font(.title2)
                    .fontWeight(.bold)
                VStack(alignment: .leading, spacing: 5) {
                    ForEach(recipe.ingredients?.components(separatedBy: ", ") ?? [], id: \.self) { ingredient in
                        Text(ingredient)
                    }
                }
                .padding(.bottom, 20)
                
                Text("How to Make It")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.top, 20)
                
                ForEach(0..<4, id: \.self) { index in
                    if let photoData = getImageData(for: index) {
                        if let uiImage = UIImage(data: photoData) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFit()
                                .frame(maxWidth: .infinity, maxHeight: 200)
                                .padding(.top, 8)
                        }
                    }
                    
                    if let descriptionText = getDescriptionText(for: index) {
                        Text(descriptionText)
                            .padding(.top, 4)
                    }
                }
                
                Text("Allergens")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.top, 20)
                
                VStack(alignment: .leading, spacing: 5) {
                    HStack {
                        if recipe.containsGluten { Text("Gluten").foregroundColor(.red) }
                        Spacer()
                        if recipe.isVegan { Text("Vegan").foregroundColor(.green) }
                        if recipe.isVegetarian { Text("Vegetarian").foregroundColor(.green) }
                    }
                    HStack {
                        if recipe.containsDairy { Text("Dairy").foregroundColor(.red) }
                        Spacer()
                        if recipe.isVegan { Text("Vegan").foregroundColor(.green) }
                        if recipe.isVegetarian { Text("Vegetarian").foregroundColor(.green) }
                    }
                    HStack {
                        if recipe.containsNuts { Text("Nuts").foregroundColor(.red) }
                        Spacer()
                        if recipe.isVegan { Text("Vegan").foregroundColor(.green) }
                        if recipe.isVegetarian { Text("Vegetarian").foregroundColor(.green) }
                    }
                    // Diğer allergenler için de benzer şekilde devam edebilirsiniz
                }
                .padding(.top, 10)
                
                Spacer()
                Button(action: {
                    pdfData = generatePDF()
                    showShareSheet.toggle()
                }) {
                    HStack {
                        Image(systemName: "arrow.down.circle.fill")
                            .font(.title2)
                            .foregroundColor(.blue)
                        Text("Download That Recipe")
                            .foregroundColor(.blue)
                            .font(.title2)
                            .italic()
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(color: .gray, radius: 3, x: 0, y: 2)
                }
                .padding(.bottom, 30)
                .sheet(isPresented: $showShareSheet, content: {
                    if let pdfData = pdfData {
                        ShareSheet(activityItems: [pdfData])
                    }
                })
            }
            .padding()
            .navigationBarTitle(Text(recipe.title ?? ""), displayMode: .inline)
            .onAppear {
                isFavorite = recipe.isFavorite
            }
        }
    }
    
    private func saveContext() {
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    private func getImageData(for index: Int) -> Data? {
        switch index {
        case 0:
            return recipe.photo
        case 1:
            return recipe.photo1
        case 2:
            return recipe.photo2
        case 3:
            return recipe.photo3
        default:
            return nil
        }
    }
    
    private func getDescriptionText(for index: Int) -> String? {
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
    
    private func addToMenu() {
        switch recipe.category {
        case "Garde Manger":
            if recipeSelectionManager.selectedAmuseBouche == nil {
                recipeSelectionManager.selectedAmuseBouche = recipe
            } else if recipeSelectionManager.selectedSaladDressing == nil {
                recipeSelectionManager.selectedSaladDressing = recipe
            }
        case "Entrimetrier":
            if recipeSelectionManager.selectedSoupCrouton == nil {
                recipeSelectionManager.selectedSoupCrouton = recipe
            } else if recipeSelectionManager.selectedHotStarterSauce == nil {
                recipeSelectionManager.selectedHotStarterSauce = recipe
            } else if recipeSelectionManager.selectedMainCourse == nil {
                recipeSelectionManager.selectedMainCourse = recipe
            }
        case "Saucier":
            recipeSelectionManager.selectedMainCourse = recipe
        case "Patisserie":
            recipeSelectionManager.selectedDessert = recipe
        default:
            break
        }
    }
    
    private func generatePDF() -> Data {
        let pdfMetaData = [
            kCGPDFContextCreator: "Your App",
            kCGPDFContextAuthor: "Your Name",
            kCGPDFContextTitle: recipe.title ?? "Recipe"
        ]
        let format = UIGraphicsPDFRendererFormat()
        format.documentInfo = pdfMetaData as [String: Any]
        
        let pageWidth = 8.5 * 72.0
        let pageHeight = 11 * 72.0
        let pageRect = CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight)
        
        let renderer = UIGraphicsPDFRenderer(bounds: pageRect, format: format)
        return renderer.pdfData { (context) in
            context.beginPage()
            
            // Background Image
            if let backgroundImage = UIImage(named: "background_image_name") {
                let context = context.cgContext
                context.saveGState()
                context.draw(backgroundImage.cgImage!, in: pageRect)
                context.restoreGState()
            }
            
            let titleAttributes = [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 24, weight: .bold)
            ]
            let textAttributes = [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18, weight: .regular)
            ]
            
            var text = recipe.title ?? "Unknown Title"
            text.draw(at: CGPoint(x: 20, y: 20), withAttributes: titleAttributes)
            
            var yPosition = 60.0
            text = "Ingredients: \(recipe.ingredients ?? "No Ingredients")"
            text.draw(at: CGPoint(x: 20, y: yPosition), withAttributes: textAttributes)
            
            yPosition += 40.0
            for index in 0..<4 {
                if let descriptionText = getDescriptionText(for: index) {
                    text = descriptionText
                    text.draw(at: CGPoint(x: 20, y: yPosition), withAttributes: textAttributes)
                    yPosition += 30.0
                }
            }
            
            // Logo for Recipes PDF
            if let logo = UIImage(named: "logo_image_name") {
                let logoWidth: CGFloat = 100  // Büyük logo boyutu
                let logoHeight: CGFloat = 100
                let logoX = pageRect.minX + 20
                let logoY = pageRect.minY + 20
                let logoRect = CGRect(x: logoX, y: logoY, width: logoWidth, height: logoHeight)
                
                if let cgImage = logo.cgImage {
                    let context = context.cgContext
                    context.saveGState()
                    context.draw(cgImage, in: logoRect)
                    context.restoreGState()
                }
            }
            yPosition += 40.0
            for index in 0..<4 {
                if let descriptionText = getDescriptionText(for: index) {
                    text = descriptionText
                    text.draw(at: CGPoint(x: 20, y: yPosition), withAttributes: textAttributes)
                    yPosition += 30.0
                }
            }
        }
    }
    // Similar PDF generation function for Shopping List with smaller logo in the upper-right corner
    private func generateShoppingListPDF() -> Data {
        let pdfMetaData = [
            kCGPDFContextCreator: "Your App",
            kCGPDFContextAuthor: "Your Name",
            kCGPDFContextTitle: "Shopping List"
        ]
        let format = UIGraphicsPDFRendererFormat()
        format.documentInfo = pdfMetaData as [String: Any]
        
        let pageWidth = 8.5 * 72.0
        let pageHeight = 11 * 72.0
        let pageRect = CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight)
        
        let renderer = UIGraphicsPDFRenderer(bounds: pageRect, format: format)
        return renderer.pdfData { (context) in
            context.beginPage()
            
            let titleAttributes = [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 24, weight: .bold)
            ]
            let textAttributes = [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18, weight: .regular)
            ]
            
            var text = "Shopping List"
            text.draw(at: CGPoint(x: 20, y: 20), withAttributes: titleAttributes)
            
            var yPosition = 60.0
            
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
                text.draw(at: CGPoint(x: 20, y: yPosition), withAttributes: textAttributes)
                yPosition += 30.0
            }
            
            // Logo for Shopping List PDF
            if let logo = UIImage(named: "logo_image_name") {
                let logoWidth: CGFloat = 80  // Orta boyutlu logo boyutu
                let logoHeight: CGFloat = 80
                let logoX = pageRect.maxX - logoWidth - 20
                let logoY = pageRect.minY + 20
                let logoRect = CGRect(x: logoX, y: logoY, width: logoWidth, height: logoHeight)
                
                if let cgImage = logo.cgImage {
                    let context = context.cgContext
                    context.saveGState()
                    context.draw(cgImage, in: logoRect)
                    context.restoreGState()
                }
            }
        }
    }
    }
