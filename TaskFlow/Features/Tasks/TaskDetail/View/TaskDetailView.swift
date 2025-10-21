//
//  TaskDetailView.swift
//  TaskFlow
//
//  Created by ali cihan on 19.10.2025.
//

import SwiftUI

struct TaskDetailView: View {
    @State var viewModel: ViewModel
    
    init(task: TaskItem) {
        self.viewModel = ViewModel(task: task)
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
            Text("ToDo")
                .bold()
                .frame(height: 20)
            //
            Text("To Do list")
                .frame(height: 50)
                .multilineTextAlignment(.leading)
        }
    }
    
    private var ongoingSection: some View {
        Section {
            NavigationLink {
                WIPDetailView(taskItem: viewModel.task)
            }
            label: {
                VStack(alignment: .leading) {
                    Text("Ongoing")
                        .bold()
                        .frame(height: 20)
                    Divider()
                    ForEach(viewModel.task.ongoingContent, id:\.id) { media in
                        
                        switch media.mediaType {
                        case .audio:
                            Label("Audio note attached", systemImage: "waveform")
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
                            Label("Video attached: \(media.mediaURL?.lastPathComponent ?? "")", systemImage: "video.fill")
                        }
                    }
                }
            }
        }
    }
    
    private var reviewSection: some View {
        Section {
            Text("Review")
                .bold()
                .frame(height: 20)
            ForEach($viewModel.task.checklist, id:\.id) { $item in
                Toggle(isOn: $item.isChecked) {
                    Text(item.title)
                }
                .toggleStyle(iOSCheckboxToggleStyle())
            }
        }
    }
}

#Preview {
    NavigationStack {
        TaskDetailView(task: TaskItem.mock)
    }
}



