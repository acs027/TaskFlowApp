//
//  GlassMediaButton.swift
//  TaskFlow
//
//  Created by ali cihan on 21.10.2025.
//

import SwiftUI

struct GlassMediaButton: ViewModifier {
    let isItemsExpanded: Bool
    let offset: CGFloat
    let degree: CGFloat
    let duration: TimeInterval
    
    func body(content: Content) -> some View {
        content
            .opacity(isItemsExpanded ? 1 : 0)
            .glassEffect(.regular.interactive())
            .offset(buttonOffset(degree: degree))
            .animation(.spring(duration: duration, bounce: 0.2), value: isItemsExpanded)
    }
    
    private func buttonOffset(degree: CGFloat) -> CGSize {
        return CGSize(width: -offset * cos(degree * .pi / 180), height: -offset * sin(degree * .pi / 180))
    }
}
