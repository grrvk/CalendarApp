//
//  CalendarAppApp.swift
//  CalendarApp
//
//  Created by Vika Granadzer on 04.05.2023.
//

import SwiftUI

@main
struct CalendarAppApp: App {
    
    let persistentContainer = CoreDataManager.shared.persistentContainer

    var body: some Scene {
        WindowGroup {
            ContentView().environment(\.managedObjectContext, CoreDataManager.shared.persistentContainer.viewContext)
            
        }
    }
}
