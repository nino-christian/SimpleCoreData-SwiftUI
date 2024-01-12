//
//  CoreDataRepository.swift
//  SimpleCoreData
//
//  Created by Nino-Christian on 1/11/24.
//

import Foundation
import CoreData


enum CoreDataError: Error {
    case CoreDataStorageError(Error)
    case CoreDataFetchError(Error)
    case CoreDataSaveError(Error)
    case CoreDataDeleteError(Error)
}


protocol CoreDataRepositoryProtocol {
    associatedtype T: NSManagedObject
    
    var container: NSPersistentContainer { get }
    
    init(modelName: String)
    func fetchRequest() -> NSFetchRequest<T>
    func addEntity(entity: T)
    func deleteEntity(index: IndexSet)
    func updateEntity(withPredicate predicate: NSPredicate, updateHandler: (T) -> Void)
    func saveData()
}

final class CoreDataRepository<T: NSManagedObject>: CoreDataRepositoryProtocol {

    var container: NSPersistentContainer
    
    init(modelName: String) {
        self.container = NSPersistentContainer(name: modelName)
        self.container.loadPersistentStores { (description, error) in
            if let error = error {
                fatalError("Failed to load persistent stores: \(CoreDataError.CoreDataStorageError(error))")
            } else {
                print("Successfuly loaded persistent stores")
            }
        }
    }
    
    func fetchRequest() -> NSFetchRequest<T> {
        return NSFetchRequest<T>(entityName: String(describing: T.self))
    }
    
    func addEntity(entity: T) {
        let context = container.viewContext
        context.insert(entity)
        saveData()
    }
    
    func deleteEntity(withPredicate predicate: NSPredicate) {
        let context = container.viewContext
        
        let fetchRequest = NSFetchRequest<T>(entityName: String(describing: T.self))
        fetchRequest.predicate = predicate
        
        do {
            let fetchedResults = try context.fetch(fetchRequest)
            if let existingItem = fetchedResults.first {
                context.delete(existingItem)
                saveData()
            } else {
                print("Item does not exist in Core Data.")
            }
            
         
        } catch {
            print("Could not fetch request: \(CoreDataError.CoreDataStorageError(error))")
        }
    }
    
    func updateEntity<T: NSManagedObject>(withPredicate predicate: NSPredicate, updateHandler: (T) -> Void) {
        let context = container.viewContext
        
        let fetchRequest = NSFetchRequest<T>(entityName: String(describing: T.self))
        fetchRequest.predicate = predicate
        
        do {
            let fetchedResults = try context.fetch(fetchRequest)
            if let existingItem = fetchedResults.first {
                updateHandler(existingItem)
                saveData()
            } else {
                print("Item does not exist in Core Data.")
            }
            
         
        } catch {
            print("Could not fetch request: \(CoreDataError.CoreDataStorageError(error))")
        }
        
    }
    
    func saveData() {
        let context = container.viewContext
        if context.hasChanges{
            do {
                try context.save()
            } catch {
                fatalError("Failed to save to storage: \(CoreDataError.CoreDataSaveError(error))")
            }
        }
    }
}
