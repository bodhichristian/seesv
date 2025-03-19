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
    
    @State private var selection: Set<CSVAnalysis> = []
    @State private var newAnalysisTitle = "New Analysis"
    @State private var isAnalyzing = false
    @State private var multipleItemsSelected = false
    @State private var filteringFavorites: Bool = false
    
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
            
            Grid(horizontalSpacing: 10, verticalSpacing: 10) {
                GridRow {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(.twitterBlue.opacity(0.2))
                        .frame(height: 60)
                        .overlay {
                            VStack {
                                Image(systemName: "plus.circle")
                                    .font(.title2)
                                    .padding(2)
                                
                                Text("Import CSV")
                                    .font(.caption)
                            }
                            .foregroundColor(.white)
                        }
                        .onTapGesture {
                            importCSVFile()
                        }
                        
                    
                    RoundedRectangle(cornerRadius: 10)
                        .fill(.green.opacity(0.2))
                        .frame(height: 60)
                        .overlay {
                            VStack {
                                Image(systemName: "square.and.arrow.up.circle")
                                    .font(.title2)
                                    .padding(2)
                                
                                Text("Export Analysis")
                                    .font(.caption)
                            }
                            .foregroundColor(.white)

                        }
                        .onTapGesture {
                            // export logic
                        }
                }
                
                GridRow {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(.yellow.opacity(0.2))
                        .frame(height: 60)
                        .overlay {
                            VStack {
                                Image(systemName: filteringFavorites ? "star.fill" : "star")
                                    .font(.title2)
                                    .padding(2)
                                
                                Text("Favorites")
                                    .font(.caption)
                            }
                            .foregroundColor(.white)
                        }
                        .onTapGesture {
                            withAnimation {
                                filteringFavorites.toggle()
                            }
                        }
                    
                    RoundedRectangle(cornerRadius: 10)
                        .fill(.red.opacity(0.2))
                        .frame(height: 60)
                        .overlay {
                            VStack {
                                Image(systemName: "trash")
                                    .font(.title2)
                                    .padding(2)
                                
                                Text("Recently deleted")
                                    .font(.caption)
                            }
                            .foregroundColor(.white)
                            
                        }
                        .onTapGesture {
                            // favorite logic
                        }
                }
            }
            .padding(.horizontal)
            .padding(.top)
            
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
