//
//  CSVService.swift
//  SeeSV
//
//  Created by christian on 3/1/25.
//

import Foundation
import PythonKit

class CSVService {
    static let sys = Python.import("sys").path.append("/Library/Frameworks/Python.framework/Versions/Current/lib/python3.9/site-packages")
    static let pd = Python.import("pandas")
    
    static func readCSV(filePath: String) -> CSVAnalysis {
        let df = pd.read_csv(filePath)
        df.columns = df.columns.str.replace(" ", "_").str.lower()
        
        // Convert column names to Swift array
        let pyHeaders = df.columns.tolist()
        let headersArray = Array(pyHeaders) // Convert Python list to Swift array of PythonObject
        let headers = headersArray.map { "\($0)" } // Convert each element to String
        
        // Convert rows to Swift array
        let pyRows = df.values.tolist()
        let rowsArray = Array(pyRows) // Convert Python list to Swift array of PythonObject
        let rows = rowsArray.map { row in
            let rowArray = Array(row) // Convert inner Python list to Swift array
            return rowArray.map { "\($0)" } // Convert each element to String
        }
        
        let insights = CSVService.calculateInsights(for: df)
        return CSVAnalysis(headers: headers, rows: rows, insights: insights)
    }
    
    static func calculateInsights(for df: PythonObject) -> Insights {
        let posts = Int(df["create_post"].sum()) ?? 0
        let likes = Int(df["likes"].sum()) ?? 0
        
        let impressions = Int(df["impressions"].sum()) ?? 0
        let engagements = Int(df["engagements"].sum()) ?? 0
        let engagementRate = Double(engagements) / Double(impressions) * 100
        let avgDailyEngagment = Double((df["engagements"] / df["impressions"]).sum()) ?? 0
        
        let profileVists = Int(df["profile_visits"].sum()) ?? 0
        let newFollowers = Int(df["new_follows"].sum()) ?? 0
        let unfollows = Int(df["unfollows"].sum()) ?? 0
        let netFollowerChange = newFollowers - unfollows
        
        
        let insights = Insights(
            totalPosts: posts,
            totalLikes: likes,
            totalImpressions: impressions,
            totalEngagements: engagements,
            engagementRate: engagementRate,
            avgDailyEngagment: avgDailyEngagment,
            profileVists: profileVists,
            totalNewFollowers: newFollowers,
            totalUnfollows: unfollows,
            netFollowerChange: netFollowerChange
        )
        
        print("Total Likes: \(insights.totalLikes)")
        return insights
    }
}




