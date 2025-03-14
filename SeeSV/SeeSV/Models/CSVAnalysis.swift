//
//  CSVAnalysis.swift
//  SeeSV
//
//  Created by christian on 3/8/25.
//

import Foundation
import SwiftData

@Model
class CSVAnalysis {
    var id: UUID = UUID()
    var dateCreated = Date.now
    var name: String
    var headers: [String]
    var rows: [[String]]
    
    @Attribute(.externalStorage)
    var insights: Insights?
    
    init(name: String = Date.now.formatted(date: .abbreviated, time: .shortened), headers: [String] = [], rows: [[String]] = [[]], insights: Insights? = nil) {
        self.name = name
        self.headers = headers
        self.rows = rows
        self.insights = insights
    }
}

// MARK: - Mock Data
extension CSVAnalysis {
    static func mock() -> CSVAnalysis {
        let insights =  Insights(
            totalPosts: 30,
            totalLikes: 1200,
            totalImpressions: 5000,
            totalEngagements: 800,
            engagementRate: 0.16,
            avgDailyEngagment: 26.7,
            profileVists: 300,
            totalNewFollowers: 120,
            totalUnfollows: 20,
            netFollowerChange: 100
        )
        
        return CSVAnalysis(
            name: "Mock Analysis",
            headers: ["Date", "Likes", "Comments"],
            rows: [
                ["2024-03-01", "120", "15"],
                ["2024-03-02", "98", "20"],
                ["2024-03-03", "150", "25"]
            ],
            insights: insights
        )
    }
}
