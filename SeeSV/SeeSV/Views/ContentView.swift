//
//  ContentView.swift
//  SeeSV
//
//  Created by christian on 3/1/25.
//

import SwiftUI

struct ContentView: View {
    @Environment(CSVService.self) var csvService
    
    @State private var isTargeted: Bool = false
    @State private var isLoading: Bool = false
    
//    private var message: String  {
//        if isTargeted {
//
//        }
//    }
    
    var body: some View {
        VStack {
            if isLoading {
                VStack {
                    ProgressView("Analyzing data...")
                        .progressViewStyle(.linear)
                        .font(.title2)
                        .frame(maxWidth: 200)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(.twitterBlue.opacity(0.2))
                .transition(.opacity)
            }
            else if csvService.headers.isEmpty {
                Text("Drag & Drop a CSV file here")
                    .font(.title2)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(isTargeted ? .twitterBlue.opacity(0.2) : .gray.opacity(0.2)) // Changes on hover
                    .animation(.easeInOut, value: isTargeted)
                    .onDrop(of: ["public.file-url"], isTargeted: $isTargeted) { providers in
                        handleFileDrop(providers)
                    }
            } else {
                VStack {
                    TableView(headers: csvService.headers, rows: csvService.rows)
                    
                    if let insights = csvService.insights {
                        HStack {
                            VStack {
                                Text("Account Overview Insights")
                                    .font(.title2)
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
                    
                    isLoading = true// Show loading state
                    
                    Task {
                        do {
                            try  csvService.readCSV(filePath: url.path)
                            withAnimation { isLoading = false }  // Hide loading state with animation
                        } catch {
                            print(error.localizedDescription)
                            withAnimation { isLoading = false }  // Ensure loading state is reset
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
