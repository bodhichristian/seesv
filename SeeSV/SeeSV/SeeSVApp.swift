//
//  SeeSVApp.swift
//  SeeSV
//
//  Created by christian on 3/1/25.
//

import SwiftUI
import SwiftData

@main
struct SeeSVApp: App {
    let csvService = CSVService()
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .environment(csvService)
                .modelContainer(for: CSVAnalysis.self)
        }
    }
}
