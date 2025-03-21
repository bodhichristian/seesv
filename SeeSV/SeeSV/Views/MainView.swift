//
//  MainView.swift
//  SeeSV
//
//  Created by christian on 3/7/25.
//

import SwiftUI
import SwiftData

struct MainView: View {
    @Environment(\.modelContext) var modelContext
    @FocusState private var titleFieldFocused
    
    @Query(sort: [SortDescriptor(\CSVAnalysis.dateCreated, order: .reverse)]) var analyses: [CSVAnalysis]
    
    @State private var isAnalyzing = false
    @State private var filteringFavorites: Bool = false
    @State private var multipleItemsSelected = false
    @State private var selection: Set<CSVAnalysis> = []
    
    private var filteredAnalyses: [CSVAnalysis] {
        if filteringFavorites {
            analyses.filter { $0.isFavorite }
        } else {
            analyses
        }
    }
    
    var body: some View {
        NavigationSplitView {
            sidebar
        } detail: {
            if selection.isEmpty && isAnalyzing == false {
                WelcomeView()
            } else {
                if isAnalyzing {
                    DragDropView(selectedAnalysis: Binding(
                        get: { selection.first },
                        set: { if let newValue = $0 { selection = [newValue] } }
                    ), creatingNewAnalysis: $isAnalyzing)
                } else {
                    if !selection.isEmpty {
                        if selection.count == 1, let selectedAnalysis = selection.first {
                            AnalysisView(analysis: selectedAnalysis)
                                .id(selectedAnalysis.id)
                        } else {
                            MultiSelectionView(selectedAnalyses: $selection)
                        }
                    } else {
                        Text("Select an analysis to view details")
                    }
                }
            }
        }
        .onChange(of: selection) { oldValue, newValue in
            isAnalyzing = false
            multipleItemsSelected = newValue.count > 1
        }
    }
    
    private var sidebar: some View {
        VStack {
            SidebarGridModule(
                filteringFavorites: $filteringFavorites,
                isAnalyzing: $isAnalyzing,
                selection: $selection,
                modelContext: modelContext
            )
            
            List(selection: $selection) {
                Section("Recents"){
                    ForEach(filteredAnalyses) { analysis in
                        FlexibleTextField(analysis: analysis)
                            .tag(analysis)
                            .contextMenu {
                                Button {
                                    analysis.isFavorite.toggle()
                                } label: {
                                    analysis.isFavorite
                                    ? Text("Unfavorite")
                                    : Text("Favorite")
                                }
                                
                                Button("Delete \"\(analysis.name)\"", role: .destructive) {
                                    delete([analysis])
                                }
                            }
                    }
                }
            }
            
            
            
            Button("New Analysis") {
                isAnalyzing = true
            }
            .buttonStyle(.bordered)
            .padding()
        }
        .frame(minWidth: 250)
    }
    
    private func delete(_ analyses: [CSVAnalysis]) {
        withAnimation {
            analyses.forEach { analysis in
                modelContext.delete(analysis)
            }
            selection.removeAll()
        }
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

// Placeholder for multi-selection view
struct MultiSelectionView: View {
    @Binding var selectedAnalyses: Set<CSVAnalysis>
    
    var body: some View {
        VStack {
            Text("\(selectedAnalyses.count) Selected: ")
                .font(.headline)
            Text("Select a single analysis to view details or delete multiple from the sidebar.")
        }
    }
}

#Preview {
    MainView()
}
