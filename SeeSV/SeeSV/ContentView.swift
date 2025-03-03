//
//  ContentView.swift
//  SeeSV
//
//  Created by christian on 3/1/25.
//

import SwiftUI

struct ContentView: View {
    @State private var service = CSVService()
    @State private var headers: [String] = []
    @State private var rows: [[String]] = []
    @State private var hasDroppedFile: Bool = false
    
    var body: some View {
        VStack {
            if headers.isEmpty {
                Text("Drag & Drop a CSV file here")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.gray.opacity(0.2))
                
                    .onDrop(of: ["public.file-url"], isTargeted: nil) { providers in
                        handleFileDrop(providers)
                    }
            } else {
                TableView(headers: headers, rows: rows)
                
            }
        }
    }
    
    
    func handleFileDrop(_ providers: [NSItemProvider]) -> Bool {
        guard let item = providers.first else { return false }
        item.loadItem(forTypeIdentifier: "public.file-url", options: nil) { (urlData, error) in
            DispatchQueue.main.async {
                if let urlData = urlData as? Data,
                   let url = URL(dataRepresentation: urlData, relativeTo: nil) {
                    
                    Task {
                        let csvData = try service.readCSV(filePath: url.path)
                        
                        guard let csvHeaders = csvData.first else { return }
                        let csvRows = Array(csvData.dropFirst())
                        headers = csvHeaders
                        rows = csvRows
                    }
                }
            }
        }
        return true
    }
}

#Preview {
    ContentView()
}
