//
//  WelcomeView.swift
//  SeeSV
//
//  Created by christian on 3/17/25.
//

import SwiftUI

struct WelcomeView: View {
    var body: some View {
        VStack {
            Text("SeeSV")
                .font(.largeTitle)
                .fontWeight(.medium)
                .padding(.bottom)
            Text("Select an analysis from the sidebar menu, or click New Analysis to process a new CSV.")
                .frame(maxWidth: 300)
                .multilineTextAlignment(.center)
        }
    }
}

#Preview {
    WelcomeView()
}
