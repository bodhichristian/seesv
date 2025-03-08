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
    
    @Query(sort: \CSVAnalysis.dateCreated) var analyses: [CSVAnalysis]
    @State private var selectedAnalysis: CSVAnalysis?
    @State private var newAnalysisTitle = "New Analysis"
    @State private var creatingNewAnalysis = false
    @FocusState private var titleFieldFocused

    
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
                if creatingNewAnalysis {
                    HStack {
    //                    Image(systemName: "list.bullet.circle.fill")
    //                        .foregroundStyle(.blue)
    //                        .offset(x: 3)
                        TextField("New List", text: $newAnalysisTitle)
                            .textFieldStyle(.plain)
                            .focused($titleFieldFocused)
                            .offset(x: 1)
                    }
                    .onChange(of: titleFieldFocused) {
                        if !titleFieldFocused {
                            selectedAnalysis?.name = newAnalysisTitle
                            creatingNewAnalysis = false
                        }
                    }
                }
                
            }
            
           
            
            Button("New Analysis") {
                creatingNewAnalysis = true
                let newAnalysis = CSVAnalysis()
                
                modelContext.insert(newAnalysis)
                selectedAnalysis = newAnalysis
                titleFieldFocused = true
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
