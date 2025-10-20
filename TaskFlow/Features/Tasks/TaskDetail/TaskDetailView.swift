//
//  TaskDetailView.swift
//  TaskFlow
//
//  Created by ali cihan on 19.10.2025.
//

import SwiftUI

struct TaskDetailView: View {
    @State var viewModel: ViewModel
    
    init(task: Task) {
        self.viewModel = ViewModel(task: task)
    }
    
    var body: some View {
        VStack{
            Form {
                taskState
                Section {
                    Text("ToDo")
                        .bold()
                        .frame(height: 20)
                    
                    Text("To Do list")
                        .frame(height: 50)
                        .multilineTextAlignment(.leading)
                }
                Section {
                    Text("Work in progress.")
                        .bold()
                        .frame(height: 20)
                    ForEach(viewModel.task.workInProgress, id:\.id) { media in
                        switch media.mediaType {
                        case .audio:
                            Label("Audio note attached", systemImage: "waveform")
                        case .image:
                            AsyncImage(url: media.mediaURL) { image in
                                image.resizable()
                            } placeholder: {
                                Color.clear
                            }
                        case .text:
                            Text(media.text ?? "")
                        case .video:
                            Label("Video attached: \(media.mediaURL?.lastPathComponent ?? "")", systemImage: "video.fill")
                        }
                    }
                }
                Section {
                    Text("Control")
                        .bold()
                        .frame(height: 20)
                    ForEach($viewModel.task.checklist, id:\.id) { $item in
                        Toggle(item.title, isOn: $item.isChecked)
                        
                    }
                }
                Section {
                    Text("Done")
                        .bold()
                        .frame(height: 50)
                }
            }
        }
        .navigationTitle("Task Detail")
    }
    
    private var taskState: some View {
        HStack {
            TaskStateLabel(title: "Planned", background: .yellow)
            TaskStateLabel(title: "Todo", background: .blue)
            TaskStateLabel(title: "Ongoing", background: .teal)
            TaskStateLabel(title: "Control", background: .green)
        }
        .listRowBackground(Color(uiColor: UIColor.systemGroupedBackground))
        
    }
    
//    private func binding(key: String): Binding<Bool> {
//        if let item = viewModel.task.checklist[key] {
//            get: { item },
//            set: { newValue in
//                someBoolValue = newValue
//            }
//        }
//    }
}

#Preview {
    TaskDetailView(task: Task.mock)
}


