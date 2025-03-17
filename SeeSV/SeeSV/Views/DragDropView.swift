//
//  DragDropView.swift
//  SeeSV
//
//  Created by christian on 3/8/25.
//

import SwiftUI

struct DragDropView: View {
    @Environment(\.modelContext) var modelContext
    @Binding var selectedAnalysis: CSVAnalysis?
    @Binding var creatingNewAnalysis: Bool
    @State private var isTargeted: Bool = false
    @State private var isLoading: Bool = false
    
    var body: some View {
        if isLoading {
            LoadingView()
        } else {
            Text("Drag & Drop a CSV file here")
                .font(.title2)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(isTargeted ? .twitterBlue.opacity(0.2) : .gray.opacity(0.2)) // Changes on hover
                .animation(.easeInOut, value: isTargeted)
                .onDrop(of: ["public.file-url"], isTargeted: $isTargeted) { providers in
                    handleFileDrop(providers)
                }
        }
    }
    
    func handleFileDrop(_ providers: [NSItemProvider]) -> Bool {
        guard let item = providers.first else { return false }
        item.loadItem(forTypeIdentifier: "public.file-url", options: nil) { (urlData, error) in
            DispatchQueue.main.async {
                if let urlData = urlData as? Data,
                   let url = URL(dataRepresentation: urlData, relativeTo: nil) {
                    
                    isLoading = true// Show loading state
                    
                    Task {
                        let analysis = CSVService.readCSV(filePath: url.path)
                        modelContext.insert(analysis)
                        try modelContext.save()
                        selectedAnalysis = analysis
                        withAnimation {
                            creatingNewAnalysis = false
                            isLoading = false
                        }
                    }
                }
            }
        }
        return true
    }
}

#Preview {
    DragDropView(selectedAnalysis: .constant(CSVAnalysis()), creatingNewAnalysis: .constant(false))
}
