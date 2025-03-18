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
    
    @Query(sort: \CSVAnalysis.dateCreated) var analyses: [CSVAnalysis]
    
    // Use Set for multi-selection
    @State private var selectedAnalyses: Set<CSVAnalysis> = []
    @State private var newAnalysisTitle = "New Analysis"
    @State private var creatingNewAnalysis = false
    // Track when multiple items are selected
    @State private var isMultiSelectionActive = false
    
    var body: some View {
        NavigationSplitView {
            sidebar
        } detail: {
            if selectedAnalyses.isEmpty && creatingNewAnalysis == false{
                WelcomeView()
            } else {
                if creatingNewAnalysis {
                    DragDropView(selectedAnalysis: Binding(
                        get: { selectedAnalyses.first },
                        set: { if let newValue = $0 { selectedAnalyses = [newValue] } }
                    ), creatingNewAnalysis: $creatingNewAnalysis)
                } else {
                    if !selectedAnalyses.isEmpty {
                        if selectedAnalyses.count == 1, let selectedAnalysis = selectedAnalyses.first {
                            AnalysisView(analysis: selectedAnalysis)
                                .id(selectedAnalysis.id)
                        } else {
                            MultiSelectionView(selectedAnalyses: $selectedAnalyses)
                        }
                    } else {
                        Text("Select an analysis to view details")
                    }
                }
            }
        }
        .onChange(of: selectedAnalyses) { oldValue, newValue in
            isMultiSelectionActive = newValue.count > 1
        }
    }
    
    private var sidebar: some View {
        VStack {
            List(selection: $selectedAnalyses) {
                ForEach(analyses) { analysis in
                    FlexibleTextField(analysis: analysis)
                        .tag(analysis)
                        .contextMenu {
                            Button("Delete \"\(analysis.name)\"", role: .destructive) {
                                delete([analysis])
                            }
                        }
                }
            }
            
            
            Button("New Analysis") {
                creatingNewAnalysis = true
            }
            .buttonStyle(.bordered)
            .padding()
        }
        .frame(minWidth: 200)
    }
    
    private func delete(_ analyses: [CSVAnalysis]) {
        withAnimation {
            analyses.forEach { analysis in
                modelContext.delete(analysis)
            }
            selectedAnalyses.removeAll()
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
