//
//  AudioPlayerView.swift
//  TaskFlow
//
//  Created by ali cihan on 21.10.2025.
//

import SwiftUI
import AVKit

struct AudioPlayerView: View {
    @State private var audioPlayer: AVAudioPlayer?
    let url: URL?
    
    var body: some View {
        VStack(spacing: 20) {
            Button("Play Audio") {
                playSound()
            }
            
            Button("Stop Audio") {
                audioPlayer?.stop()
            }
        }
        .font(.title2)
    }
    
    func playSound() {
        //        if let soundURL = Bundle.main.url(forResource: "sound", withExtension: "mp3") {
        if let soundURL = url {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
                audioPlayer?.play()
            } catch {
                print("Error playing audio: \(error.localizedDescription)")
            }
        } else {
            print("Audio file not found")
        }
    }
}
