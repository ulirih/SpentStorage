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
    var context: NSManagedObjectContext
    
    private var container: NSPersistentContainer!
    
    init() {
        container = NSPersistentContainer(name: "SpentStorage")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
        context = container.newBackgroundContext()
    }
    
    func save() throws {
        if context.hasChanges {
            try context.save()
        }
    }
    
    func getData(entityName: String,
                 predicate: NSPredicate?,
                 sort: [NSSortDescriptor]?,
                 completion: @escaping (_ result: Result<[NSManagedObject], Error>) -> Void
    ) {
        context.perform {
            do {
                let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)
                fetchRequest.predicate = predicate
                fetchRequest.sortDescriptors = sort
                let entities = try self.context.fetch(fetchRequest)
                
                DispatchQueue.main.async {
                    completion(.success(entities))
                }
            } catch let error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
}
