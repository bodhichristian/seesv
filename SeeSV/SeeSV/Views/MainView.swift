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
    
    @Query var analyses: [CSVAnalysis]
    @State private var selectedAnalysis: CSVAnalysis?
    
    var body: some View {
        NavigationSplitView {
            sidebar
        } detail: {
            if selectedAnalysis?.headers == [] {
                DragDropView(selectedAnalysis: $selectedAnalysis)
            } else {
                AnalysisView(analysis: selectedAnalysis ?? CSVAnalysis())
            }
        }
    }
    
    private var sidebar: some View {
        VStack {
            List(selection: $selectedAnalysis) {
                ForEach(analyses) { analysis in
                    Text(analysis.name)
                        .tag(analysis)
                }
            }
            
            Button("New Analysis") {
                let newAnalysis = CSVAnalysis()
                
                modelContext.insert(newAnalysis)
                selectedAnalysis = newAnalysis
            }
            .buttonStyle(.bordered)
            .padding()
        }
        .frame(minWidth: 200)
    }
}

#Preview {
    MainView()
}
