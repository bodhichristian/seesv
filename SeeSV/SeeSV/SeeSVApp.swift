//
//  SeeSVApp.swift
//  SeeSV
//
//  Created by christian on 3/1/25.
//

import SwiftUI

@main
struct SeeSVApp: App {
    let csvService = CSVService()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(csvService)
        }
    }
}
