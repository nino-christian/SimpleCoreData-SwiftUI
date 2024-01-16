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
    
    func getAllEntities(for entity: T.Type) -> [T]
    func addEntity(entity: T)
    func deleteEntity(entityProperty: String, propertyValue: Any)
    func updateEntity(entityProperty: String, propertyValue: Any, updateHandler: (T) -> Void)
}

final class CoreDataService<T: NSManagedObject>: CoreDataServiceProtocol {
    var repository: CoreDataRepository<T>
    
    init(repository: CoreDataRepository<T>) {
        self.repository = repository
    }
    
    func getAllEntities(for entity: T.Type) -> [T] {
        return repository.fetchRequest()
    }
    
    func addEntity(entity: T) {
        repository.addEntity(entity: entity)
    }
    
    func deleteEntity(entityProperty: String, propertyValue: Any) {
        repository.deleteEntity(withPredicate: NSPredicate(format: "\(entityProperty) == %@", [propertyValue]))
    }
    
    func updateEntity(entityProperty: String, propertyValue: Any, updateHandler: (T) -> Void) {
        repository.updateEntity(withPredicate: NSPredicate(format: "\(entityProperty) == %@", [propertyValue])) { (existingItem: T) in
            updateHandler(existingItem)
        }
    }
}
