//
//  SimpleCoreDataApp.swift
//  SimpleCoreData
//
//  Created by Nino-Christian on 1/11/24.
//

import SwiftUI

@main
struct SimpleCoreDataApp: App {
    @StateObject var contentViewModel: ContentViewModel = ContentViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: contentViewModel)
        }
    }
}
