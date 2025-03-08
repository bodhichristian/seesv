//
//  LoadingView.swift
//  SeeSV
//
//  Created by christian on 3/7/25.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
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
}

#Preview {
    LoadingView()
}
