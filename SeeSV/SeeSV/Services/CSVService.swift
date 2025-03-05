//
//  CSVService.swift
//  SeeSV
//
//  Created by christian on 3/1/25.
//

import Foundation
import PythonKit

@Observable
class CSVService {
    var headers: [String] = []
    var rows: [[String]] = []
    var insights: Insights? = nil
    
    func readCSV(filePath: String) throws {
        let sys = Python.import("sys")
        let pandas = Python.import("pandas")

        // Python installation path
        sys.path.append("/Library/Frameworks/Python.framework/Versions/Current/lib/python3.9/site-packages")

        do {
            // Read CSV using Pandas
            let df = pandas.read_csv(filePath)

            // Convert column names to snake_case
            df.columns = df.columns.str.replace(" ", "_").str.lower()

            // Convert column names to Swift array
            guard let dfHeaders = df.columns.tolist().map({ "\($0)" }) as? [String] else {
                print("Error: Column conversion failed.")
            }

            // Convert rows to Swift array
            guard let dfRows = df.values.tolist().map({ row in
                row.map { "\($0)" }
            }) as? [[String]] else {
                print("Error: Row conversion failed.")
            }
            
            headers = dfHeaders
            rows = dfRows
            
            insights = try calculateTotals(df: df)
        }
    }
    
    func calculateTotals(df: PythonObject) throws -> Insights {
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
        return insights
    }
}




