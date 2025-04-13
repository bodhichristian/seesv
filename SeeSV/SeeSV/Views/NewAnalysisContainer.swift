//
//  DragDropView.swift
//  SeeSV
//
//  Created by christian on 3/8/25.
//

import SwiftUI
import PythonKit

struct NewAnalysisContainer: View {
    @Environment(\.modelContext) var modelContext
    @Binding var selectedAnalysis: CSVAnalysis?
    @Binding var creatingNewAnalysis: Bool
    
    @State private var overviewFileURL: URL?
    @State private var contentFileURL: URL?
    @State private var isLoading: Bool = false
    @State private var overviewTargeted: Bool = false
    @State private var contentTargeted: Bool = false
    
    var body: some View {
        if isLoading {
            // Assuming you have a LoadingView defined
            LoadingView()
        } else {
            HStack {
                DragDropView(label: "Overview", isTargeted: $overviewTargeted) { url in
                    overviewFileURL = url
                    checkAndMerge()
                }
                
                DragDropView(label: "Content", isTargeted: $contentTargeted) { url in
                    contentFileURL = url
                    checkAndMerge()
                }
            }
        }
    }
    
    /// Checks if both URLs are set and triggers the merge if so
    private func checkAndMerge() {
        guard let overviewURL = overviewFileURL, let contentURL = contentFileURL else {
            return // Wait until both files are dropped
        }
        
        isLoading = true
        Task {
            do {
                // Read both CSVs
                let overviewAnalysis = CSVService.readCSV(filePath: overviewURL.path)
                let contentAnalysis = CSVService.readCSV(filePath: contentURL.path)
                
                // Convert to pandas DataFrames
                let overviewDf = CSVService.pd.DataFrame(
                    overviewAnalysis.rows.map { $0.map { PythonObject($0) } },
                    columns: overviewAnalysis.headers.map { PythonObject($0) }
                )
                let contentDf = CSVService.pd.DataFrame(
                    contentAnalysis.rows.map { $0.map { PythonObject($0) } },
                    columns: contentAnalysis.headers.map { PythonObject($0) }
                )
                
                // Merge on "date" column with an inner join
                let mergedDf = overviewDf.merge(contentDf, on: "date", how: "inner")
                
                // Extract merged headers and rows
                let pyHeaders = mergedDf.columns.tolist()
                let newHeaders = Array(pyHeaders).map { "\($0)" }
                let pyRows = mergedDf.values.tolist()
                let newRows = Array(pyRows).map { $0.map { "\($0)" } }
                
                // Create new CSVAnalysis with merged data
                let insights = CSVService.calculateInsights(for: mergedDf)
                let newAnalysis = CSVAnalysis(headers: newHeaders, rows: newRows, insights: insights)
                
                // Save to model context
                modelContext.insert(newAnalysis)
                try modelContext.save()
                
                // Update state
                selectedAnalysis = newAnalysis
                withAnimation {
                    creatingNewAnalysis = false
                    isLoading = false
                }
            } catch {
                print("Error processing CSVs: \(error)")
                isLoading = false
            }
        }
    }
}

#Preview {
    NewAnalysisContainer(selectedAnalysis: .constant(CSVAnalysis()), creatingNewAnalysis: .constant(false))
}
