//
//  CoreDataManager.swift
//  SpentStorage
//
//  Created by andrey perevedniuk on 01.11.2022.
//

import Foundation
import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    
    private var container: NSPersistentContainer!
    
    init() {
        container = NSPersistentContainer(name: "SpentStorage")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    public var context: NSManagedObjectContext {
        get {
            return container.viewContext
        }
    }
    
    func save() throws {
        if(container.viewContext.hasChanges){
            try container.viewContext.save()
        }
    }
}
