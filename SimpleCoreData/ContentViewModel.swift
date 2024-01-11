//
//  ContentViewModel.swift
//  SimpleCoreData
//
//  Created by Nino-Christian on 1/11/24.
//

import Foundation
import CoreData

protocol ContentViewModelProtocol: ObservableObject {

    var coreDataService: CoreDataService<ItemEntity> { get set }
    
    init(coreDataService: CoreDataService<ItemEntity>)
    
    func getItems()
    func addItem(item: ItemModel)
    func deleteItem(index: IndexSet)
    func updateItem(item: ItemModel)
   
}


final class ContentViewModel: ContentViewModelProtocol {
    
    @Published var itemsList: [ItemEntity]
    
    var coreDataService: CoreDataService<ItemEntity>
    
    required init(coreDataService: CoreDataService<ItemEntity>) {
        self.itemsList = []
        self.coreDataService = coreDataService
    }
    
    func getItems() {
        self.itemsList = coreDataService.getAllEntities()
    }
    
    func addItem(item: ItemModel) {
        let context = coreDataService.repository.container.viewContext
        let itemEntity = ItemEntity(context: context)
        itemEntity.name = item.name
        itemEntity.quantity = item.quantity
        coreDataService.addEntity(entity: itemEntity)
    }
    
    func deleteItem(index: IndexSet) {
        coreDataService.deleteEntity(index: index)
    }
    
    func updateItem(item: ItemModel) {
        let context = coreDataService.repository.container.viewContext
        let itemEntity = ItemEntity(context: context)
        itemEntity.name = item.name
        itemEntity.quantity = item.quantity
        coreDataService.updateEntity(entity: itemEntity)
    }
}
