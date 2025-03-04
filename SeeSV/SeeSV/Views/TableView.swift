//
//  CSVView.swift
//  SeeSV
//
//  Created by christian on 3/1/25.
//

import SwiftUI


struct TableView: View {
    let headers: [String]
    let rows: [[String]]
    
    var body: some View {
        ScrollView(.horizontal) {
            VStack(alignment: .leading, spacing: 0) {
                HeaderView(headers: headers)
                    .background(.ultraThinMaterial)
                
                List(rows, id: \.self) { row in
                    HStack {
                        ForEach(row, id: \.self) { cell in
                            Text(cell)
                                .frame(maxWidth: .infinity, alignment: .trailing)
                        }
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct HeaderView: View {
    let headers: [String]
    
    var body: some View {
        HStack {
            ForEach(headers, id: \.self) { header in
                Text(header)
                    .lineLimit(1)
                    .fontWeight(.bold)
                    .frame(minWidth: 100, maxWidth: .infinity, alignment: .trailing)
            }
        }
        .padding()
    }
}

#Preview {
    TableView(headers: [], rows: [])
}
