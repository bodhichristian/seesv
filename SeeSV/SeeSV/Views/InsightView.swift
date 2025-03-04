//
//  InsightView.swift
//  SeeSV
//
//  Created by christian on 3/4/25.
//

import SwiftUI

struct InsightView: View {
    let label: String
    let value: Int
    
    var body: some View {
        RoundedRectangle(cornerRadius: 10)
            .foregroundStyle(.secondary)
            .frame(width: 100, height: 100)
            .overlay {
                VStack {
                    Text(String(value))
                        .font(.largeTitle)
                        .fontWeight(.semibold)
                        .fontDesign(.monospaced)
                    
                    Text(label)
                        .font(.title2)
                        .fontWeight(.medium)
                        .foregroundStyle(.black)

                }
            }
    }
}

#Preview {
    InsightView(label: "Likes", value: 100)
}
