//
//  ContentViewModel.swift
//  SimpleCoreData
//
//  Created by DNA-User on 1/11/24.
//

import Foundation
import CoreData

enum CoreDataError: Error {
    case CoreDataFetchError(Error)
    case CoreDataSaveError(Error)
    case CoreDataDeleteError(Error)
}

protocol CoreDataViewModelProtocol: ObservableObject {
    var container: NSPersistentContainer { get }
    
    func fetchRequest()
    func addItem(item: ItemModel)
    func deleteItem(index: IndexSet)
    func update(item: ItemModel)
    func saveData()
}

final class ContentViewModel: CoreDataViewModelProtocol {
    
    let container: NSPersistentContainer
    @Published var itemsList: [ItemEntity] = []
    
    init() {
        self.container = NSPersistentContainer(name: "ItemModel")
        self.container.loadPersistentStores { (description, error) in
            if let error = error {
                fatalError("Unable to load persistent stores: \(error)")
            } else {
                print("Loading persistent stores successful!")
            }
        }
        fetchRequest()
    }
    
    func fetchRequest() {
        let request = NSFetchRequest<ItemEntity>(entityName: "ItemEntity")
        
        do {
            let result = try container.viewContext.fetch(request)
            self.itemsList = result
        } catch {
            print("Fetch entity failed: \(CoreDataError.CoreDataFetchError(error))")
        }
    }
    
    func addItem(item: ItemModel) {
        let newItem = ItemEntity(context: container.viewContext)
        newItem.name = item.name
        newItem.quantity = item.quantity
        saveData()
    }
    
    func deleteItem(index: IndexSet) {
        guard let index = index.first else { return }
        let itemEntity = itemsList[index]
        container.viewContext.delete(itemEntity)
        saveData()
    }
    
    func update(item: ItemModel) {
        
    }
    
    func saveData() {
        if container.viewContext.hasChanges {
            do {
                try container.viewContext.save()
                fetchRequest()
            } catch {
                print("Failed to save: \(CoreDataError.CoreDataSaveError(error))")
            }
        }
        
    }
}
