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
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .modelContainer(for: CSVAnalysis.self)
        }
    }
}
