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
    
    @State private var selectedAnalysis: CSVAnalysis? = nil
    @State private var newAnalysisTitle = "New Analysis"
    @State private var creatingNewAnalysis = false
    
    var body: some View {
        NavigationSplitView {
            sidebar
        } detail: {
            if creatingNewAnalysis {
                DragDropView(selectedAnalysis: $selectedAnalysis, creatingNewAnalysis: $creatingNewAnalysis)
            } else {
                if let selectedAnalysis {
                    AnalysisView(analysis: selectedAnalysis)
                }
            }
        }
    }
    
    private var sidebar: some View {
        VStack {
            List(selection: $selectedAnalysis) {
                ForEach(analyses) { analysis in
                    FlexibleTextField(analysis: analysis)
                        .tag(analysis)
                        .contextMenu {
                            Button("Delete \"\(selectedAnalysis?.name ?? "Analysis")\"", role: .destructive) {
                                deleteAnalysis(analysis)
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
    
    private func deleteAnalysis(_ analysis: CSVAnalysis) {
        withAnimation {
            modelContext.delete(analysis)
        }
    }
}

#Preview {
    MainView()
}
