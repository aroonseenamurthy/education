//
//  educationApp.swift
//  education
//
//  Created by Programmer on 8/1/26.
//

import SwiftUI
import CoreData

@main
struct TinyLearnApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
