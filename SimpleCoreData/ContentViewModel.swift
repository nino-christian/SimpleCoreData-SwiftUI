//
//  ContentViewModel.swift
//  SimpleCoreData
//
//  Created by Nino-Christian on 1/11/24.
//

import Foundation
import CoreData
import Combine

protocol ContentViewModelProtocol: ObservableObject {

    var coreDataService: CoreDataService<ItemEntity> { get set }
    
    init(coreDataService: CoreDataService<ItemEntity>)
    
    func getItems()
    func addItem(item: ItemModel)
    func deleteItem(index: IndexSet)
    func updateItem(newItem: ItemModel)
   
}


final class ContentViewModel: ContentViewModelProtocol {
    
    var coreDataService: CoreDataService<ItemEntity>
    @Published var itemsList: [ItemModel]
    
    private var cancellables: Set<AnyCancellable> = []
    
    required init(coreDataService: CoreDataService<ItemEntity>) {
        self.itemsList = []
        self.coreDataService = coreDataService
    
    }
//    private func setupBindings() {
//        coreDataService
//    }
    
    func getItems() {
        self.itemsList = coreDataService.getAllEntities(for: ItemEntity.self).map({ entity in
            ItemModel(entity: entity)
        })
    }
    
    func addItem(item: ItemModel) {
        let context = coreDataService.repository.container.viewContext
        let itemEntity = ItemEntity(context: context)
        itemEntity.name = item.name
        itemEntity.quantity = item.quantity
        coreDataService.addEntity(entity: itemEntity)
        getItems()
    }
    
    func deleteItem(index: IndexSet) {
        //coreDataService.deleteEntity(index: index)
    }
    
    func updateItem(newItem: ItemModel) {
        coreDataService.updateEntity(entityProperty: "name", propertyValue: newItem.name) { existingItem in
            
            existingItem.name = newItem.name
            existingItem.quantity = newItem.quantity
        }
    }
}
