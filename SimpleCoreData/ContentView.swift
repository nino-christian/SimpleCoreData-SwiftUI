//
//  ContentView.swift
//  SimpleCoreData
//
//  Created by Nino-Christian on 1/11/24.
//

import SwiftUI

struct ItemModel {
    var name: String
    var quantity: Int32
}

struct ContentView: View {
    @State private var itemName: String = ""
    @State private var itemQuantity: String = ""
    
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
                List {
                    ForEach(viewModel.itemsList, id: \.self) { entity in
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Item: \(entity.name ?? "No Name")")
                                    .font(.headline)
                                Text("Quantity: \(entity.quantity)")
                                    .font(.subheadline)
                            }
                        }
                    }
                    .onDelete(perform: viewModel.deleteItem)
                    .listStyle(.plain)
                }
            }
            .padding()
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
