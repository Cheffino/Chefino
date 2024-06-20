//
//  TutorialView.swift
//  Chefino
//
//  Created by Mehmet Akkavak on 20.06.2024.
//

import SwiftUI
import Lottie

struct TutorialView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                LottieView(url: URL(string: "https://assets10.lottiefiles.com/packages/lf20_znjydzg7.json")!)
                    .frame(width: 300, height: 300)
                
                Text("How to use Chefino")
                    .font(.title)
                    .padding(.top, 10)
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        tutorialItem(imageName: "book.fill", title: "Browse Recipes", description: "Use the 'Recipes' tab to browse through a variety of delicious recipes.", color: .orange)
                        tutorialItem(imageName: "star.fill", title: "Save Favorites", description: "Tap the star icon to save your favorite recipes for quick access later.", color: .yellow)
                        tutorialItem(imageName: "person.crop.circle.fill", title: "Create an Account", description: "Sign up to personalize your experience and save your preferences.", color: .blue)
                        tutorialItem(imageName: "list.bullet", title: "Explore Categories", description: "Discover recipes based on categories like vegan, vegetarian, gluten-free, and more.", color: .green)
                        tutorialItem(imageName: "magnifyingglass", title: "Use the Search", description: "Use the search bar to quickly find recipes by ingredients or name.", color: .gray)
                        tutorialItem(imageName: "questionmark.circle.fill", title: "Get Support", description: "Visit the 'Support' tab for help and to contact our team.", color: .purple)
                        
                        Text("Enjoy cooking with Chefino!")
                            .font(.title2)
                            .padding(.top)
                    }
                    .padding()
                }
            }
            .navigationTitle("Tutorial")
        }
    }

    private func tutorialItem(imageName: String, title: String, description: String, color: Color) -> some View {
        HStack {
            Image(systemName: imageName)
                .resizable()
                .frame(width: 40, height: 40)
                .foregroundColor(color)
            VStack(alignment: .leading) {
                Text(title)
                    .font(.headline)
                Text(description)
                    .font(.subheadline)
            }
        }
    }
}

struct TutorialView_Previews: PreviewProvider {
    static var previews: some View {
        TutorialView()
    }
}
