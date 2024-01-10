//
//  ContentView.swift
//  SimpleCoreData
//
//  Created by DNA-User on 1/11/24.
//

import SwiftUI

struct ItemModel {
    var name: String
    var quantity: Int32
}

struct ContentView: View {
    @State var itemName: String = ""
    @State var itemQuantity: String = ""
    
    @ObservedObject var viewModel: ContentViewModel

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
                    ForEach(viewModel.itemsList) { entity in
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
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: ContentViewModel())
    }
}
