//
//  FlexibleTextField.swift
//  SeeSV
//
//  Created by christian on 3/8/25.
//

import SwiftUI

struct FlexibleTextField: View {
    @Bindable var analysis: CSVAnalysis
    @FocusState private var isEditing

    var body: some View {
        TextField("", text: $analysis.name)
            .textFieldStyle(.plain)
            .focused($isEditing)
            .onTapGesture(count: 2) { isEditing = true }
            .onSubmit { isEditing = false }
    }
}

#Preview {
    FlexibleTextField(analysis: CSVAnalysis())
}
