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
    
    @State private var localValue: Int = 0
    
    var body: some View {
        RoundedRectangle(cornerRadius: 10)
            .foregroundStyle(.black.gradient.opacity(0.6))
            .frame(width: 100, height: 100)
            .overlay {
                VStack {
                    Text(String(localValue))
                        .contentTransition(.numericText())
                        .font(.largeTitle)
                        .fontWeight(.semibold)
                        .fontDesign(.monospaced)
                    
                    
                    Text(label)
                        .font(.title2)
                        .foregroundStyle(.secondary)
                    
                }
            }
            .onAppear {
                withAnimation {
                    localValue = value
                }
            }
    }
}

#Preview {
    InsightView(label: "Likes", value: 100)
}
