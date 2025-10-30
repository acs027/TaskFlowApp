//
//  MediaURLCorrectionService.swift
//  TaskFlow
//
//  Created by ali cihan on 27.10.2025.
//

import Foundation


// The media folder path in simulator changes on every run. This service modify the media url path according to new app folder path.
struct MediaURLCorrectionService {
    static func updateMediaURL(task: TaskItem) {
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]

        for workItem in task.inProgressContent {
            guard let mediaURL = workItem.mediaURL else {
                print("⚠️ WorkItem has no mediaURL")
                continue
            }

            // The desired destination path for this file
            let correctDestination = documentsURL.appendingPathComponent(mediaURL.lastPathComponent)

            if mediaURL != correctDestination {
                // Fix the URL
                workItem.mediaURL = correctDestination
                print("🔧 Updated URL to \(correctDestination.lastPathComponent)")

                // Optionally move the file if it exists elsewhere
                if FileManager.default.fileExists(atPath: mediaURL.path) {
                    do {
                        try FileManager.default.moveItem(at: mediaURL, to: correctDestination)
                        print("📦 Moved file to Documents directory.")
                    } catch {
                        print("❌ Failed to move file: \(error)")
                    }
                }
            } else {
                print("✅ \(mediaURL.lastPathComponent) is already correct.")
            }
        }
    }
}
