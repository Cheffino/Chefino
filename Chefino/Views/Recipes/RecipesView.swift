//
//  RecipesView.swift
//  Chefino
//
//  Created by Mehmet Akkavak on 8.06.2024.
import SwiftUI

struct RecipesView: View {
    @Environment(\.managedObjectContext) private var viewContext

    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Spacer()
                NavigationLink(destination: RecipeFormView()) {
                    ZStack {
                        Circle()
                            .fill(Color(UIColor.systemTeal))
                            .frame(width: 50, height: 50)
                        Image(systemName: "plus.app.fill")
                            .foregroundColor(.white)
                            .font(.system(size: 30))
                    }
                }
                .padding(.trailing, 10)
            }
            .padding(.top, 10)
            .frame(maxWidth: .infinity, alignment: .trailing)
            
            HStack {
                NavigationLink(destination: SaucierRecipesView()) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color(UIColor.systemTeal))
                            .frame(width: UIScreen.main.bounds.width * 0.45, height: UIScreen.main.bounds.width * 0.45)
                        VStack {
                            Image(systemName: "frying.pan.fill")
                                .font(.system(size: 40))
                                .foregroundColor(.white)
                            Text("SAUCIER")
                                .foregroundColor(.white)
                                .font(.title2)
                                .fontWeight(.bold)
                                .multilineTextAlignment(.center)
                        }
                    }
                }

                NavigationLink(destination: GardeMangerRecipesView()) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color(UIColor.systemPink))
                            .frame(width: UIScreen.main.bounds.width * 0.45, height: UIScreen.main.bounds.width * 0.45)
                        VStack {
                            Image(systemName: "leaf.arrow.circlepath")
                                .font(.system(size: 40))
                                .foregroundColor(.white)
                            Text("GARDE MANGER")
                                .foregroundColor(.white)
                                .font(.title2)
                                .fontWeight(.bold)
                                .multilineTextAlignment(.center)
                        }
                    }
                }
            }

            HStack {
                NavigationLink(destination: EntrimetrierRecipesView()) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color(UIColor.systemYellow))
                            .frame(width: UIScreen.main.bounds.width * 0.45, height: UIScreen.main.bounds.width * 0.45)
                        VStack {
                            Image(systemName: "flame.fill")
                                .font(.system(size: 40))
                                .foregroundColor(.white)
                            Text("ENTRIMETRIER")
                                .foregroundColor(.white)
                                .font(.title2)
                                .fontWeight(.bold)
                                .multilineTextAlignment(.center)
                        }
                    }
                }

                NavigationLink(destination: PatisserieRecipesView()) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color(UIColor.systemIndigo))
                            .frame(width: UIScreen.main.bounds.width * 0.45, height: UIScreen.main.bounds.width * 0.45)
                        VStack {
                            Image(systemName: "birthday.cake")
                                .font(.system(size: 40))
                                .foregroundColor(.white)
                            Text("PATISSERIE")
                                .foregroundColor(.white)
                                .font(.title2)
                                .fontWeight(.bold)
                                .multilineTextAlignment(.center)
                        }
                    }
                }
            }

            HStack {
                NavigationLink(destination: BakeryRecipesView()) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color(UIColor.systemGray))
                            .frame(width: UIScreen.main.bounds.width * 0.45, height: UIScreen.main.bounds.width * 0.45)
                        VStack {
                            Image(systemName: "oven")
                                .font(.system(size: 40))
                                .foregroundColor(.white)
                            Text("BAKERY")
                                .foregroundColor(.white)
                                .font(.title2)
                                .fontWeight(.bold)
                                .multilineTextAlignment(.center)
                        }
                    }
                }

                NavigationLink(destination: YourMenuView()) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color(UIColor.systemBrown))
                            .frame(width: UIScreen.main.bounds.width * 0.45, height: UIScreen.main.bounds.width * 0.45)
                        VStack {
                            Image(systemName: "list.bullet")
                                .font(.system(size: 40))
                                .foregroundColor(.white)
                            Text("YOUR MENU")
                                .foregroundColor(.white)
                                .font(.title2)
                                .fontWeight(.bold)
                                .multilineTextAlignment(.center)
                        }
                    }
                }
            }
        }
        .padding()
        .navigationTitle("Recipes")
    }
}

struct RecipesView_Previews: PreviewProvider {
    static var previews: some View {
        RecipesView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
