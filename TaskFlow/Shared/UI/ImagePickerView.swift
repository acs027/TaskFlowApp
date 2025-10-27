//
//  ImagePickerView.swift
//  TaskFlow
//
//  Created by ali cihan on 20.10.2025.
//
import SwiftUI
import PhotosUI
import SwiftData

struct ImagePickerView: View {
    @Environment(\.modelContext) private var context
    @State private var selectedItem: PhotosPickerItem?
    @State private var image: UIImage?
    let taskItem: TaskItem
    
    var body: some View {
        
        PhotosPicker(selection: $selectedItem, matching: .images) {
            Label("Add an image", systemImage: "photo.fill")
                .labelStyle(.iconOnly)
                .frame(width: 50, height: 50)
        }
        .onChange(of: selectedItem) { oldItem ,newItem in
            Task { await handlePickedImage(from: newItem) }
        }
    }
    
    func handlePickedImage(from item: PhotosPickerItem?) async {
        guard let item else { return }
        do {
            if let data = try await item.loadTransferable(type: Data.self),
               let uiImage = UIImage(data: data) {
                image = uiImage
                
                // Save image to Documents
                let imageID = UUID()
                let imageURL = try saveImageToDocuments(uiImage, id: imageID)
                let workItem = WorkItem(id: imageID, text: "My image", mediaURL: imageURL, mediaType: .image)
                taskItem.inProgressContent.append(workItem)
                context.insert(workItem)
                try context.save()
            }
        } catch {
            print("Error saving image:", error)
        }
    }
    
    func saveImageToDocuments(_ image: UIImage, id: UUID) throws -> URL {
        let imageData = image.jpegData(compressionQuality: 0.9)!
        let fileName = id.uuidString + ".jpg"
        let destination = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent(fileName)
        try imageData.write(to: destination)
        return destination
    }
}
