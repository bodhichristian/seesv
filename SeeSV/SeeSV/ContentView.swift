//
//  ContentView.swift
//  SeeSV
//
//  Created by christian on 3/1/25.
//

import SwiftUI

struct ContentView: View {
    @Environment(CSVService.self) var csvService

    @State private var hasDroppedFile: Bool = false
    
    var body: some View {
        VStack {
            if csvService.headers.isEmpty {
                Text("Drag & Drop a CSV file here")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.gray.opacity(0.2))
                
                    .onDrop(of: ["public.file-url"], isTargeted: nil) { providers in
                        handleFileDrop(providers)
                    }
            } else {
                VStack {
                    TableView(headers: csvService.headers, rows: csvService.rows)
                                        
                    
                    if let insights = csvService.insights {
                        Text("Total posts: \(insights.totalPosts)")
                        Text("Total likes: \(insights.totalLikes)")
                        Text("Total follows: \(insights.totalNewFollowers)")
                        Text("Total unfollows: \(insights.totalUnfollows)")
                    }
                }
                
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
                        do {
                            try csvService.readCSV(filePath: url.path)
                        } catch {
                            print(error.localizedDescription)
                        }
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
