//
//  ChefinoApp.swift
//  Chefino
//
//  Created by Mehmet Akkavak on 8.06.2024.
//

import SwiftUI

@main
struct ChefinoApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
