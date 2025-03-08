//
//  ContentView.swift
//  SeeSV
//
//  Created by christian on 3/1/25.
//

import SwiftUI
import SwiftData

struct AnalysisView: View {
    @Environment(CSVService.self) var csvService
    @Environment(\.modelContext) var modelContext
    
    let analysis: CSVAnalysis
    
    var body: some View {
        VStack {
            VStack {
                TableView(headers: analysis.headers, rows: analysis.rows)
                
                if let insights = analysis.insights {
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

#Preview {
    AnalysisView(analysis: CSVAnalysis.mock())
}
