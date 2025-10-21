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
        //
        //            if let videoURL {
        //                Text("✅ Saved to Documents:")
        //                    .font(.headline)
        //                Text(videoURL.lastPathComponent)
        //                    .font(.subheadline)
        //                    .foregroundColor(.gray)
        //
        //                VideoPlayer(player: AVPlayer(url: videoURL))
        //                    .frame(height: 250)
        //                    .clipShape(RoundedRectangle(cornerRadius: 12))
        //                    .padding(.top)
        //
        //                if showSavedMessage {
        //                    Text("🎉 Saved to SwiftData!")
        //                        .font(.headline)
        //                        .foregroundColor(.green)
        //                }
        //            }
        .onChange(of: selectedItem) { newItem in
            handlePickedVideo(from: newItem)
        }
    }
    
    private func handlePickedVideo(from newItem: PhotosPickerItem?) {
        Task {
            await handlePickedVideo(from: newItem)
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
        }
        
        // MARK: - Video Handling
        func handlePickedVideo(from item: PhotosPickerItem?) async {
            guard let item else { return }
            
            do {
                if let tempURL = try await item.loadTransferable(type: URL.self) {
                    saveVideo(tempURL)
                } else if let data = try await item.loadTransferable(type: Data.self) {
                    // Fallback: write data manually
                    let tempFile = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString + ".mov")
                    try data.write(to: tempFile)
                    saveVideo(tempFile)
                }
            } catch {
                print("Error loading video: \(error)")
            }
        }
        
        func saveVideo(_ sourceURL: URL) {
            let fileName = sourceURL.lastPathComponent
            let destination = getDocumentsDirectory().appendingPathComponent(fileName)
            
            do {
                if FileManager.default.fileExists(atPath: destination.path) {
                    try FileManager.default.removeItem(at: destination)
                }
                try FileManager.default.copyItem(at: sourceURL, to: destination)
                videoURL = destination
                
                // Create and save WorkItem in SwiftData
                let item = WorkItem(text: "My picked video", mediaURL: destination, mediaType: .video)
                taskItem.ongoingContent.append(item)
                context.insert(item)
                try context.save()
                showSavedMessage = true
                
                print("✅ Video saved to Documents and SwiftData:", destination)
            } catch {
                print("Error saving video:", error)
            }
        }
        
        func getDocumentsDirectory() -> URL {
            FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        }
    }
}
