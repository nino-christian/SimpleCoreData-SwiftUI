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
    func deleteEntity(index: IndexSet)
    func updateEntity(entity: T)
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
    
    func deleteEntity(index: IndexSet) {
        repository.deleteEntity(index: index)
    }
    
    func updateEntity(entity: T) {
        repository.updateEntity(entity: entity)
    }
}
