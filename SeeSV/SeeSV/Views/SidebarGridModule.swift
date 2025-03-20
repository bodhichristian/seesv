//
//  SidebarGridModule.swift
//  SeeSV
//
//  Created by christian on 3/20/25.
//

import SwiftUI
import SwiftData

struct SidebarGridModule: View {
    @Binding var filteringFavorites: Bool
    @Binding var isAnalyzing: Bool
    @Binding var selection: Set<CSVAnalysis>
    let modelContext: ModelContext
    
    var body: some View {
        Grid(horizontalSpacing: 10, verticalSpacing: 10) {
            GridRow {
                SidebarGridItem(
                    label: "Import CSV",
                    icon: "plus.circle",
                    color: .twitterBlue) {
                        importCSVFile()
                    }
                
                SidebarGridItem(
                    label: "Export Analysis",
                    icon: "square.and.arrow.up.circle",
                    color: .green) {
                        // export logic
                    }
            }
            
            GridRow {
                SidebarGridItem(
                    label: "Favorites",
                    icon: filteringFavorites ? "star.fill" : "star",
                    color: .yellow) {
                        filteringFavorites.toggle()
                    }
                
                SidebarGridItem(
                    label: "Recently Deleted",
                    icon: "trash",
                    color: .red) {
                        // trash logic
                    }
            }
        }
        .padding(.horizontal)
        .padding(.top)

    }
    
    private func importCSVFile() {
        let panel = NSOpenPanel()
        panel.allowsMultipleSelection = false
        panel.canChooseDirectories = false
        panel.canChooseFiles = true
        //panel.allowed = ["csv"] // Filter for .csv files using extension
        isAnalyzing = true
        
        if panel.runModal() == .OK, let url = panel.url {
            do {
                let newAnalysis = CSVService.readCSV(filePath: url.path)
                
                
                // Insert into model context
                modelContext.insert(newAnalysis)
                
                // Select the new analysis
                selection = [newAnalysis]
                
                // Optionally disable creatingNewAnalysis if skipping DragDropView
                isAnalyzing = false
            }
        }
    }
}
