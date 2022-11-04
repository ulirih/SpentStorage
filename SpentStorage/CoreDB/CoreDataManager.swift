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
    
    func getData(entityName: String) throws -> [NSManagedObject] {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)
        let entities = try context.fetch(fetchRequest)
        
        return entities
        
    }
    
    func getData(entityName: String, predicate: NSPredicate) throws -> [NSManagedObject] {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)
        fetchRequest.predicate = predicate
        let entities = try context.fetch(fetchRequest)
        
        return entities
    }
    
    func getData(entityName: String, predicate: NSPredicate?, sort: [NSSortDescriptor]?) throws -> [NSManagedObject] {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = sort
        let entities = try context.fetch(fetchRequest)
        
        return entities
    }
}
