//
//  SyncLoadingView.swift
//  TaskFlow
//
//  Created by ali cihan on 30.10.2025.
//

import SwiftUI

struct SyncLoadingView: View {
    @State var rotationAngle = Angle(degrees: 0)
    
    var body: some View {
        ZStack {
            Color.clear
                .background(.ultraThinMaterial)
            Image(systemName: "arrow.trianglehead.2.clockwise.rotate.90.circle")
                .resizable()
                .opacity(0.5)
                .frame(width: 150, height: 150)
                .rotationEffect(rotationAngle)
                .animation(.linear(duration: 1).repeatForever(autoreverses: false), value: rotationAngle)
                           .onAppear {
                               rotationAngle = .degrees(360)
                           }
        }
    }
}

#Preview {
    SyncLoadingView()
}
