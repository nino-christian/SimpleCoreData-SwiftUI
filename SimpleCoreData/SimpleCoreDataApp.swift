//
//  SimpleCoreDataApp.swift
//  SimpleCoreData
//
//  Created by Nino-Christian on 1/11/24.
//

import SwiftUI

@main
struct SimpleCoreDataApp: App {
    var coreDataRepository: CoreDataRepository<ItemEntity>
    var coreDataService: CoreDataService<ItemEntity>
    var contentViewModel: ContentViewModel
    
    init() {
        self.coreDataRepository = CoreDataRepository<ItemEntity>(modelName: "ItemModel")
        self.coreDataService = CoreDataService(repository: coreDataRepository)
        self.contentViewModel = ContentViewModel(coreDataService: coreDataService)
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: contentViewModel)
        }
    }
}
