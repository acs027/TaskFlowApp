//
//  WIPDetailView.swift
//  TaskFlow
//
//  Created by ali cihan on 20.10.2025.
//

import SwiftUI
import AVKit

struct OngoingContentView: View {
    let taskItem: TaskItem
    @State var isItemsExpanded: Bool = false
    @State var offset: CGFloat = 0
    @State var isEditingText: Bool = false
    @State var textContent: String = ""
    
    @Environment(\.modelContext) var context
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            Color.clear
            ScrollView {
                VStack {
                    ForEach(taskItem.inProgressContent, id:\.id) { media in
                        switch media.mediaType {
                        case .image:
                            AsyncImage(url: media.mediaURL) { image in
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 50)
                                    
                            } placeholder: {
                                Color.clear
                                    .frame(height: 50)
                            }
                        case .text:
                            Text(media.text ?? "")
                        case .video:
                            if let url = media.mediaURL {
                                VideoPlayerView(player: AVPlayer(url: url))
                            }
                        }
                    }
                }
            }
            addContentButton
        }
        .navigationTitle("Ongoing Details")
        .sheet(isPresented: $isEditingText) {
            VStack {
                TextEditor(text: $textContent)
                        .border(.secondary)
                        .padding()
                        .padding()
                .navigationTitle("Editing todo")
                Spacer()
                Button("Add") {
                    let item = WorkItem(text: textContent, mediaType: .text)
                    taskItem.inProgressContent.append(item)
                    isEditingText.toggle()
                }
            }
        }
    }
    
    private var addContentButton: some View {
        GlassEffectContainer {
                    ZStack {
                        mediaButton(type: .text)
                        mediaButton(type: .image)
                        mediaButton(type: .video)
                    Button {
                            changeOffset()
                        
                    } label: {
                        Label("Expand", systemImage: "plus")
                            .labelStyle(.iconOnly)
                            .frame(width: 50, height: 50)
                            .foregroundStyle(.white)
                    }
                    .glassEffect(.regular.tint(.purple).interactive())
                    }
        }
        .padding()
    }
    
    private func changeOffset() {
        if isItemsExpanded {
            offset = 0
            isItemsExpanded.toggle()
        } else {
            isItemsExpanded.toggle()
            offset = 120
        }
    }
    
    @ViewBuilder
    private func mediaButton(type: MediaType) -> some View {
            switch type {
            case .text:
                Button { isEditingText.toggle() }
                label : {
                    Label("Text", systemImage: "text.document")
                        .labelStyle(.iconOnly)
                        .frame(width: 50, height: 50)
                        .modifier(GlassMediaButton(isItemsExpanded: isItemsExpanded, offset: offset, degree: 0, duration: 0.4))
                }
            case .image:
                ImagePickerView(taskItem: taskItem)
                    .modifier(GlassMediaButton(isItemsExpanded: isItemsExpanded, offset: offset, degree: 45, duration: 0.6))
                    
            case .video:
                VideoPickerView(task: taskItem, context: context)
                    .modifier(GlassMediaButton(isItemsExpanded: isItemsExpanded, offset: offset, degree: 90, duration: 0.8))
            }
    }
}



#Preview {
    NavigationStack{
        OngoingContentView(taskItem: TaskItem.mock)
    }
}




