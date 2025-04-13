//
//  DragDropView.swift
//  SeeSV
//
//  Created by christian on 4/13/25.
//

import SwiftUI
import PythonKit

struct DragDropView: View {
    let label: String
    @Binding var isTargeted: Bool
    var onDrop: (URL) -> Void // Closure to handle the dropped URL
    
    var body: some View {
        VStack {
            Text(label)
                .foregroundStyle(.white)
                .font(.headline)
            
            RoundedRectangle(cornerRadius: 12)
                .strokeBorder(style: StrokeStyle(lineWidth: 2, dash: [10]))
                .foregroundStyle(.twitterBlue)
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(isTargeted ? .twitterBlue.opacity(0.2) : .gray.opacity(0.2))
                .animation(.easeInOut, value: isTargeted)
                .onDrop(of: ["public.file-url"], isTargeted: $isTargeted) { providers in
                    guard let item = providers.first else { return false }
                    item.loadItem(forTypeIdentifier: "public.file-url", options: nil) { (urlData, error) in
                        DispatchQueue.main.async {
                            if let urlData = urlData as? Data,
                               let url = URL(dataRepresentation: urlData, relativeTo: nil) {
                                onDrop(url) // Pass the URL to the parent
                            }
                        }
                    }
                    return true
                }
                .frame(width: 300, height: 300)
                .clipShape(RoundedRectangle(cornerRadius: 20))
        }
    }
}
#Preview {
    DragDropView(label: "Overview CSV", isTargeted: .constant(false))
}
