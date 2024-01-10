//
//  ItemFormView.swift
//  SimpleCoreData
//
//  Created by DNA-User on 1/11/24.
//

import SwiftUI

struct ItemFormView: View {
    @Binding var itemName: String
    @Binding var itemQuantity: String
    var addAction: () -> Void
    
    var body: some View {
        VStack{
            AppTextField(labelText: "Item Name", text: $itemName)
            AppTextField(labelText: "Item Quantity", text: $itemQuantity)
            Button {
                addAction()
                itemName = ""
                itemQuantity = ""
            } label: {
                Text("Add Item")
                    .font(.headline)
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .foregroundColor(Color(uiColor: AppTheme.buttonForeground))
                    .background(Color(uiColor: AppTheme.buttonBackground))
                    .cornerRadius(10, antialiased: true)
            }
        }
    }
}

struct ItemFormView_Previews: PreviewProvider {

    
    static var previews: some View {
        let itemName = Binding.constant("Item Name")
        let itemQuantity =  Binding.constant("Item Quantity")
        ItemFormView(itemName: itemName, itemQuantity: itemQuantity, addAction: {})
    }
}

