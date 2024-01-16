//
//  ContentView.swift
//  SimpleCoreData
//
//  Created by Nino-Christian on 1/11/24.
//

import SwiftUI

struct ItemModel: Identifiable {
    let id = UUID()
    var name: String
    var quantity: Int32
    
    init(name: String, quantity: Int32) {
        self.name = name
        self.quantity = quantity
    }
    
    init(entity: ItemEntity) {
        self.name = entity.name ?? "No Name"
        self.quantity = entity.quantity
    }
}

struct ContentView: View {
    @State private var itemName: String = ""
    @State private var itemQuantity: String = ""
    @State private var selectedItems = Set<UUID>()
    
    @ObservedObject private var viewModel: ContentViewModel

    init(viewModel: ContentViewModel) {
        self.viewModel = viewModel
    }
    

    
    var body: some View {
        NavigationView {
            VStack {
                ItemFormView(itemName: $itemName,
                             itemQuantity: $itemQuantity,
                             addAction: {
                                    viewModel.addItem(item: ItemModel(name: itemName, quantity: Int32(itemQuantity)!))
                                }
                )
                List(selection: $selectedItems) {
                    ForEach(viewModel.itemsList, id: \.id) { entity in
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Item: \(entity.name)")
                                    .font(.headline)
                                Text("Quantity: \(entity.quantity)")
                                    .font(.subheadline)
                            }
                        }
                    }
                    .onDelete(perform: { indexSet in
                        viewModel.deleteItem(index: indexSet)
                    })
                    .listStyle(.plain)
                }
            }
            .padding()
            .toolbar {
                EditButton()
            }
            .navigationTitle("Simple CoreData")
        }
        .onAppear(perform: {
            viewModel.getItems()
        })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let coreDataRepository = CoreDataRepository<ItemEntity>(modelName: "ItemEntity")
        let coreDataService = CoreDataService(repository: coreDataRepository)
        ContentView(viewModel: ContentViewModel(coreDataService: coreDataService))
    }
}
