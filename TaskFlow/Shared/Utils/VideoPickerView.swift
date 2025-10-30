//
//  VideoPickerView.swift
//  TaskFlow
//
//  Created by ali cihan on 20.10.2025.
//

import SwiftUI
import PhotosUI
import AVKit
import SwiftData

struct VideoPickerView: View {
    @State private var selectedItem: PhotosPickerItem? = nil
    @State var viewModel: ViewModel
    
    init(task: TaskItem, context: ModelContext) {
        let viewModel = ViewModel(task: task, context: context)
        _viewModel = State(initialValue: viewModel)
    }
    
    var body: some View {
        PhotosPicker(
            selection: $selectedItem,
            matching: .videos,
            photoLibrary: .shared()
        ) {
            Label("Add a video", systemImage: "video.fill")
                .labelStyle(.iconOnly)
                .frame(width: 50, height: 50)
        }
        .onChange(of: selectedItem) { oldItem, newItem in
            handlePickedVideo(from: newItem)
        }
    }
    
    private func handlePickedVideo(from newItem: PhotosPickerItem?) {
        Task {
            await viewModel.handlePickedVideo(from: newItem)
        }
    }
}

extension VideoPickerView {
    @Observable
    class ViewModel {
        let context: ModelContext
        var videoURL: URL? = nil
        var showSavedMessage = false
        var taskItem: TaskItem
        
        init(task: TaskItem, context: ModelContext) {
            self.taskItem = task
            self.context = context
            // Load existing video if available
            if let existingItem = taskItem.inProgressContent.first(where: { $0.mediaType == .video }),
               let url = existingItem.mediaURL {
                self.videoURL = url
            }
        }
        
        // MARK: - Video Handling
        func handlePickedVideo(from item: PhotosPickerItem?) async {
            guard let item else { return }
            
            do {
                // Load as Data to ensure we have full control
                guard let data = try await item.loadTransferable(type: Data.self) else {
                    print("Failed to load video data")
                    return
                }
                
                await MainActor.run {
                    saveVideoData(data)
                }
            } catch {
                print("Error loading video: \(error)")
            }
        }
        
        func saveVideoData(_ data: Data) {
            // Create unique filename
            let fileName = "\(UUID().uuidString).mov"
            let destination = getDocumentsDirectory().appendingPathComponent(fileName)
            
            do {
                // Write data directly to Documents
                try data.write(to: destination)
                videoURL = destination
                
                // Create and save WorkItem in SwiftData
                let item = WorkItem(text: "My picked video", mediaURL: destination, mediaType: .video)
                taskItem.inProgressContent.append(item)
                try context.save()
                showSavedMessage = true
                
                print("✅ Video saved to Documents:", destination.path)
                print("✅ File exists:", FileManager.default.fileExists(atPath: destination.path))
            } catch {
                print("❌ Error saving video:", error)
            }
        }
        
        func getDocumentsDirectory() -> URL {
            FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        }
    }
}
