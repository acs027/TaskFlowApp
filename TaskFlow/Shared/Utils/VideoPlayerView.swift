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
    var isFullscreen: Bool = false
    
    var body: some View {
        ZStack {
            if isFullscreen {
                VideoPlayer(player: player)
                    .ignoresSafeArea()
            } else {
                VideoPlayer(player: player)
                    .aspectRatio(16/9, contentMode: .fit)
            }
        }
       
    }
}
