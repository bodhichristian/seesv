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
    
    func readCSV(filePath: String) throws ->[[String]] {
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
            guard let headers = df.columns.tolist().map({ "\($0)" }) as? [String] else {
                print("Error: Column conversion failed.")
            }

            // Convert rows to Swift array
            guard let rows = df.values.tolist().map({ row in
                row.map { "\($0)" }
            }) as? [[String]] else {
                print("Error: Row conversion failed.")
            }

            return [headers] + rows

        }
    }
}
