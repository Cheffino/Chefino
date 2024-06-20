//
//  HomeView.swift
//  Chefino
//
//  Created by Mehmet Akkavak on 8.06.2024.
import SwiftUI

struct HomeView: View {
    let sliderData = [
        ("michelin_star", URL(string: "https://guide.michelin.com/")!),
        ("gault_and_millau", URL(string: "https://www.gaultmillau.com/")!),
        ("50_best_restaurants", URL(string: "https://www.theworlds50best.com/")!),
        ("50_best_hotels", URL(string: "https://www.worlds50besthotels.com/")!),
        ("fine_dining_lovers", URL(string: "https://www.finedininglovers.com/")!)
    ]
    
    @State private var searchText: String = ""
    @State private var showTutorial = false

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Search bar with Tutorial button
                HStack {
                    TextField("Search", text: $searchText)
                        .padding(7)
                        .padding(.horizontal, 25)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                        .overlay(
                            HStack {
                                Image(systemName: "magnifyingglass")
                                    .foregroundColor(.gray)
                                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                                    .padding(.leading, 8)
                                
                                if !searchText.isEmpty {
                                    Button(action: {
                                        self.searchText = ""
                                    }) {
                                        Image(systemName: "multiply.circle.fill")
                                            .foregroundColor(.gray)
                                            .padding(.trailing, 8)
                                    }
                                }
                            }
                        )
                        .padding(.horizontal, 10)
                    
                    Button(action: {
                        showTutorial.toggle()
                    }) {
                        Image(systemName: "questionmark.square")
                            .font(.title)
                            .foregroundColor(.blue)
                            .padding(.trailing, 10)
                    }
                    .sheet(isPresented: $showTutorial) {
                        TutorialView()
                    }
                }
                .padding(.top, 10)
                
                TabView {
                    ForEach(sliderData, id: \.0) { data in
                        NavigationLink(destination: WebView(url: data.1)) {
                            Image(data.0)
                                .resizable()
                                .scaledToFill()
                                .frame(width: UIScreen.main.bounds.width * 0.9, height: 300)
                                .clipped()
                                .cornerRadius(10)
                        }
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                .frame(width: UIScreen.main.bounds.width * 0.9, height: 300)
                .cornerRadius(10)
                .padding(.bottom, 10)

                HStack(spacing: 20) {
                    NavigationLink(destination: RecipesView()) {
                        HomeButtonView(title: "RECIPES", systemImageName: "book.fill", color: .systemOrange)
                    }
                    
                    NavigationLink(destination: CareerView()) {
                        HomeButtonView(title: "CAREER", systemImageName: "briefcase.fill", color: .systemTeal)
                    }
                }
                .padding(.horizontal)
                
                Spacer()
            }
            .navigationTitle("Home")
            .background(Color(.systemBackground))
        }
    }
}

struct HomeButtonView: View {
    let title: String
    let systemImageName: String
    let color: UIColor

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .fill(Color(color))
                .frame(height: UIScreen.main.bounds.width * 0.4)
            VStack {
                Image(systemName: systemImageName)
                    .font(.system(size: 40))
                    .foregroundColor(.white)
                Text(title)
                    .foregroundColor(.white)
                    .font(.title2)
                    .fontWeight(.bold)
            }
        }
        .frame(maxWidth: .infinity)
    }
}
