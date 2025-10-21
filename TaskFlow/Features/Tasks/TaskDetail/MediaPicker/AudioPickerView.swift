//
//  AudioPickerView.swift
//  TaskFlow
//
//  Created by ali cihan on 20.10.2025.
//
import SwiftUI
import UniformTypeIdentifiers
import SwiftData

struct AudioViewPickerViewWrapper: View {
    let taskItem: TaskItem
    @State var isPickerShowing: Bool = false
    
    var body: some View {
        Button {
            isPickerShowing.toggle()
        } label: {
            Label("Add an audio", systemImage: "waveform.path")
                .labelStyle(.iconOnly)
                .frame(width: 50, height: 50)
        }
        .navigationDestination(isPresented: $isPickerShowing) {
            AudioPickerView(taskItem: taskItem)
        }
        
    }
}

struct AudioPickerView: UIViewControllerRepresentable {
    @Environment(\.modelContext) private var context
    let taskItem: TaskItem
    
    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let types = [UTType.audio]
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: types)
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIDocumentPickerDelegate {
        var parent: AudioPickerView
        
        init(_ parent: AudioPickerView) {
            self.parent = parent
        }
        
        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            guard let pickedURL = urls.first else { return }
            do {
                let savedURL = try saveFileToDocuments(from: pickedURL)
                let item = WorkItem(text: "My audio", mediaURL: savedURL, mediaType: .audio)
                parent.taskItem.ongoingContent.append(item)
                parent.context.insert(item)
                print("✅ Audio saved to:", savedURL)
            } catch {
                print("Error saving audio:", error)
            }
        }
        
        func saveFileToDocuments(from sourceURL: URL) throws -> URL {
            let fileName = sourceURL.lastPathComponent
            let destination = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                .appendingPathComponent(fileName)
            
            if FileManager.default.fileExists(atPath: destination.path) {
                try FileManager.default.removeItem(at: destination)
            }
            
            try FileManager.default.copyItem(at: sourceURL, to: destination)
            return destination
        }
    }
}
