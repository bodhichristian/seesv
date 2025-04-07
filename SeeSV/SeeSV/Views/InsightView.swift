//
//  InsightView.swift
//  SeeSV
//
//  Created by christian on 3/4/25.
//

import SwiftUI
import SwiftUI

struct InsightView<T: Numeric & Comparable>: View {
    let label: String
    let value: T
    
    @State private var localValue: T = 0
    
    var formattedValue: String {
        if let doubleValue = localValue as? Double {
            return formatNumber(doubleValue, isInteger: false)
        } else if let intValue = localValue as? Int {
            return formatNumber(Double(intValue), isInteger: true)
        } else {
            return String(describing: localValue)
        }
    }
    
    func formatNumber(_ number: Double, isInteger: Bool) -> String {
        if number >= 100_000 {
            return String(format: "%.0fk", number / 1_000)
        } else if number >= 1_000 {
            return String(format: "%.1fk", number / 1_000)
        } else {
            return isInteger ? String(format: "%.0f", number) : String(format: "%.1f", number)
        }
    }
    
    var body: some View {
        RoundedRectangle(cornerRadius: 10)
            .foregroundStyle(.black.opacity(0.5))
            .frame(width: 150, height: 100)
            .overlay {
                VStack {
                    Text(formattedValue)
                        .contentTransition(.numericText()) // Works now because text updates reactively
                        .font(.system(size: 40))
                        .fontWeight(.semibold)
                        .foregroundStyle(.twitterBlue)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                    
                    Text(label)
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                }
                .padding()
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
