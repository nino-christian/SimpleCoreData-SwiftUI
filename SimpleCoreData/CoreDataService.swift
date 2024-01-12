//
//  CoreDataService.swift
//  SimpleCoreData
//
//  Created by Nino-Christian on 1/11/24.
//

import Foundation
import CoreData

protocol CoreDataServiceProtocol {
    associatedtype T: NSManagedObject
    
    var repository: CoreDataRepository<T> { get set }
    
    init(repository: CoreDataRepository<T>)
    
    func getAllEntities() -> [T]
    func addEntity(entity: T)
    func deleteEntity(for entity: T.Type, entityProperty: String, propertyValue: Any)
    func updateEntity(for entity: T.Type, entityProperty: String, propertyValue: Any, updateHandler: (T) -> Void)
}

final class CoreDataService<T: NSManagedObject>: CoreDataServiceProtocol {
    var repository: CoreDataRepository<T>
    
    init(repository: CoreDataRepository<T>) {
        self.repository = repository
    }
    
    func getAllEntities() -> [T] {
        let fetchRequest = repository.fetchRequest()
        do {
            return try repository.container.viewContext.fetch(fetchRequest)
        } catch {
            print("Failed fetching entities: \(CoreDataError.CoreDataFetchError(error))")
        }
        return []
    }
    
    func addEntity(entity: T) {
        repository.addEntity(entity: entity)
    }
    
    func deleteEntity<T: NSManagedObject>(for entity: T.Type, entityProperty: String, propertyValue: Any) {
        repository.deleteEntity(withPredicate: NSPredicate(format: "\(entityProperty) == %@", [propertyValue]))
    }
    
    func updateEntity<T: NSManagedObject>(for entity: T.Type, entityProperty: String, propertyValue: Any, updateHandler: (T) -> Void) {
        repository.updateEntity(withPredicate: NSPredicate(format: "\(entityProperty) == %@", [propertyValue])) { (existingItem: T) in
            updateHandler(existingItem)
        }
    }
}
