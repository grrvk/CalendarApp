//
//  CoreDataManager.swift
//  CalendarApp
//
//  Created by Vika Granadzer on 05.05.2023.
//

import Foundation
import CoreData
import SwiftUI

class CoreDataManager{
    
    let persistentContainer: NSPersistentContainer
    static let shared: CoreDataManager = CoreDataManager()
    
    init(){
        persistentContainer = NSPersistentContainer(name: "ToDoModel")
        let url = URL.storeURL(for: "group.vv.CalendarApp", databaseName: "ToDoModel")
        let storeDescription = NSPersistentStoreDescription(url: url)
        persistentContainer.persistentStoreDescriptions = [storeDescription]
        
        persistentContainer.loadPersistentStores{ description, error in
            if let error = error {
                fatalError("Unable to initialize Core Data \(error)")
            }
        }
    }

}

public extension URL{
    static func storeURL(for appGroup: String, databaseName: String) -> URL{
        guard let fileContainer = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroup) else {
            fatalError("Unable to create URL for \(appGroup)")
        }
        
        return fileContainer.appendingPathComponent("\(databaseName).sqlite")
    }
}
