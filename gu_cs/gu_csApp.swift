//
//  gu_csApp.swift
//  gu_cs
//
//  Created by Tony Chen on 11/12/24.
//

import SwiftUI

@main
struct gu_csApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
