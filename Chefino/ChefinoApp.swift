//
//  ChefinoApp.swift
//  Chefino
//
//  Created by Mehmet Akkavak on 8.06.2024.
import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseAppCheck
@main
struct ChefinoApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    let persistenceController = PersistenceController.shared
    @StateObject private var colorSchemeManager = ColorSchemeManager()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(RecipeSelectionManager())
                .environmentObject(colorSchemeManager)
                .environment(\.colorScheme, colorSchemeManager.isDarkMode ? .dark : .light)
                .onAppear {
                    // UUID ataması eksik varlıkları kontrol et ve UUID ata
                    persistenceController.assignUUIDsIfNeeded()
                }
        }
    }
}

class ColorSchemeManager: ObservableObject {
    @Published var isDarkMode: Bool = false
}
