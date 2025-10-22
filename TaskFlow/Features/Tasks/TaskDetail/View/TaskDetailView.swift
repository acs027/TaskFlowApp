//
//  TaskDetailView.swift
//  TaskFlow
//
//  Created by ali cihan on 19.10.2025.
//

import SwiftUI
import SwiftData
import AVKit

struct TaskDetailView: View {
    @Environment(UserManager.self) var userManager
    @State var viewModel: ViewModel
    @State var isEditingTodo: Bool = false
    @State var isEditingReview: Bool = false
    @State var isEditingOngoingContent: Bool = false
    
    init(task: TaskItem, context: ModelContext) {
        self.viewModel = ViewModel(task: task, context: context)
    }
    
    var body: some View {
        Form {
            taskState
            todoSection
            ongoingSection
            reviewSection
            Section {
                Text("Done")
                    .bold()
                    .frame(height: 50)
            }
        }
        .navigationDestination(isPresented: $isEditingReview) {
            ChecklistEditView(viewModel: $viewModel)
        }
        .navigationDestination(isPresented: $isEditingOngoingContent, destination: {
            WIPDetailView(taskItem: viewModel.task)
        })
        .navigationTitle("Task Detail")
    }
    
    private var taskState: some View {
        HStack {
            TaskStateLabel(title: "Planned", background: .yellow)
            TaskStateLabel(title: "Todo", background: .blue)
            TaskStateLabel(title: "Ongoing", background: .teal)
            TaskStateLabel(title: "Review", background: .green)
        }
        .listRowBackground(Color(uiColor: UIColor.systemGroupedBackground))
        
    }
    
    private var todoSection: some View {
        Section {
            HStack {
                Text("ToDo")
                    .bold()
                    .frame(height: 20)
                Spacer()
                if userManager.role == .admin {
                    Button("Edit") {
                        isEditingTodo.toggle()
                    }
                }
            }
            
            Text(viewModel.task.todoList)
                .frame(height: 50)
                .multilineTextAlignment(.leading)
        }
        .sheet(isPresented: $isEditingTodo) {
            TodoEditView(viewModel: $viewModel)
        }
    }
    
    private var ongoingSection: some View {
        Section {
            VStack(alignment: .leading) {
                Text("Ongoing")
                    .bold()
                    .frame(height: 20)
                Spacer()
                Button("Edit") {
                    isEditingOngoingContent.toggle()
                }
                Divider()
                ForEach(viewModel.task.ongoingContent, id:\.id) { media in
                    switch media.mediaType {
                    case .image:
                        AsyncImage(url: media.mediaURL) { image in
                            image.resizable()
                                .frame(width: 50, height: 50)
                        } placeholder: {
                            Color.blue
                                .frame(width: 50, height: 50)
                        }
                    case .text:
                        Text(media.text ?? "")
                    case .video:
                        VStack {
                            if let url = media.mediaURL {
                                VideoPlayerView(player: AVPlayer(url: url))
                                Label("Video attached: \(media.mediaURL?.lastPathComponent ?? "")", systemImage: "video.fill")
                            }
                        }
                        
                    }
                }
            }
            
        }
    }
    
    private var reviewSection: some View {
        Section {
            HStack {
                Text("Review")
                    .bold()
                    .frame(height: 20)
                Spacer()
                if userManager.role == .admin {
                    Button("Edit") {
                        isEditingReview.toggle()
                    }
                }
            }
            ForEach($viewModel.task.checklist, id:\.id) { $item in
                Toggle(isOn: $item.isChecked) {
                    Text(item.title)
                }
                .toggleStyle(iOSCheckboxToggleStyle())
            }
            
        }
    }
}

//#Preview {
//    NavigationStack {
//        TaskDetailView(task: TaskItem.mock)
//    }
//}



