//
//  SidebarGridItem.swift
//  SeeSV
//
//  Created by christian on 3/20/25.
//

import SwiftUI

struct SidebarGridItem: View {
    let label: String
    let icon: String
    let color: Color
    let action: () -> Void
    
    @State private var isHovered: Bool = false
    
    var body: some View {
        RoundedRectangle(cornerRadius: 10)
            .fill(color.opacity(0.2))
            .frame(height: 60)
            .overlay {
                VStack {
                    Image(systemName: icon)
                        .font(.title2)
                        .padding(2)
                    
                    Text(label)
                        .font(.subheadline)
                }
                .foregroundColor(.primary)
            }
            .overlay {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(color, lineWidth: 1)
                    .opacity(isHovered ? 1 : 0)
            }
            .onHover { hovering in
                    withAnimation(.easeInOut(duration: 0.1)) {
                        isHovered = hovering
                    }
                }
            .onTapGesture {
                action()
            }
    }
}

#Preview {
    SidebarGridItem(label: "Import", icon: "plus.circle", color: .twitterBlue) {
        // some logic
    }
}
