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
    func updateEntity(entity: T)
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
    
    func deleteEntity(index: IndexSet) {
        
    }
    
    func updateEntity(entity: T) {
        
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
