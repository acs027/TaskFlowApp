//
//  VideoPlayerView.swift
//  TaskFlow
//
//  Created by ali cihan on 21.10.2025.
//

import SwiftUI
import AVKit

struct VideoPlayerView: View {
    let player: AVPlayer
    
    var body: some View {
        VideoPlayer(player: player)
            .frame(width: 100)
    }
}
