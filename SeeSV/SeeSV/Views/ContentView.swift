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
                        
                        HStack {
                            VStack {
                                Text("Insights")
                                    .font(.largeTitle)
                                    .frame(width: 300, height: 100)
                                HStack {
                                    InsightView(label: "Posts", value: insights.totalPosts)
                                    InsightView(label: "Likes", value: insights.totalLikes)
                                }
                            }
                            
                            
                            VStack {
                                // Upper right row
                                HStack {
                                    InsightView(label: "Impressions", value: insights.totalImpressions)
                                    InsightView(label: "Engagements", value: insights.totalEngagements)
                                    InsightView(label: "Engagement Rate", value: insights.engagementRate)
                                    InsightView(label: "Daily Average", value: insights.avgDailyEngagment)
                                }
                                
                                // Lower right row
                                HStack {
                                    InsightView(label: "Profile Visits", value: insights.profileVists)
                                    InsightView(label: "Follower Change", value: insights.netFollowerChange)
                                    InsightView(label: "Follows", value: insights.totalNewFollowers)
                                    InsightView(label: "Unfollows", value: insights.totalUnfollows)
                                }
                            }
                        }
                        .padding()
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
