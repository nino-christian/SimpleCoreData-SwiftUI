//
//  AppTextField.swift
//  SimpleCoreData
//
//  Created by DNA-User on 1/11/24.
//

import SwiftUI

struct AppTextField: View {
    var labelText: String
    @Binding var text: String
    
    var body: some View {
        TextField(labelText, text: $text)
            .font(.headline)
            .padding(.leading)
            .frame(height: 55)
            .frame(maxWidth: .infinity)
            .foregroundColor(Color(uiColor: AppTheme.textFieldForeground))
            .background(Color(uiColor: AppTheme.textFieldBackground))
            .cornerRadius(10)
    }
}


struct AppTextField_Previews: PreviewProvider {
    static var previews: some View {
        let text: Binding<String> = Binding.constant("Sample Text")
        AppTextField(labelText: "Sample Text", text: text)
    }
}
