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
    @Environment(UserPreferences.self) var prefs
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
                Text(TaskState.completed.rawValue)
                    .bold()
                    .frame(height: 50)
            }
        }
        .safeAreaInset(edge: .bottom, content: {
            changeStatusSavePDFButtons
        })
        .navigationDestination(isPresented: $isEditingReview) {
            ChecklistEditView(viewModel: $viewModel)
        }
        .navigationDestination(isPresented: $isEditingOngoingContent, destination: {
            OngoingContentView(taskItem: viewModel.task)
        })
        .sheet(isPresented: $isEditingTodo) {
            TodoEditView(viewModel: $viewModel)
        }
        .navigationTitle("Task Detail")
    }
    
    private var taskState: some View {
        HStack {
            ForEach(TaskState.allCases, id:\.id) { state in
                if state != .initial {
                    TaskStateLabel(taskState: state, currentState: viewModel.task.taskState)
                }
            }
        }
        .listRowBackground(Color(uiColor: UIColor.systemGroupedBackground))
        
    }
    
    private var todoSection: some View {
        Section {
            HStack {
                Text("To do")
                    .bold()
                    .frame(height: 20)
                Spacer()
                if prefs.userRole == .admin {
                    Button("Edit") {
                        isEditingTodo.toggle()
                    }
                }
            }
            
            if !viewModel.task.taskDescription.isEmpty {
                Text(viewModel.task.taskDescription)
                    .frame(height: 50)
                    .multilineTextAlignment(.leading)
            }
        }
    }
    
    @ViewBuilder
    private var changeStatusSavePDFButtons: some View {
        if viewModel.isStateButton() {
            Button {
                changeStatus()
            } label: {
                Label("Change Status -> \(viewModel.task.taskState.nextStep.rawValue)", systemImage: "arrowshape.right.circle")
                    .padding()
                    .glassEffect()
            }
            .padding()
        } else {
            ConvertToPDFView(task: viewModel.task)
                .padding()
                .glassEffect()
                .padding()
        }
    }
    
    private var ongoingSection: some View {
        Section {
            VStack(alignment: .leading) {
                HStack {
                    Text("Ongoing")
                        .bold()
                        .frame(height: 20)
                    Spacer()
                    Button("Edit") {
                        isEditingOngoingContent.toggle()
                    }
                }
                Divider()
                ForEach(viewModel.task.inProgressContent, id:\.id) { media in
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
                if prefs.userRole == .admin {
                    Button("Edit") {
                        isEditingReview.toggle()
                    }
                }
            }
            ForEach($viewModel.task.checklist, id:\.id) { $item in
                Toggle(isOn: $item.isChecked) {
                    Text(item.title)
                }
                .disabled(viewModel.isChecklistToggleDisabled())
                .toggleStyle(iOSCheckboxToggleStyle())
            }
            
        }
    }
    
    private func changeStatus() {
        viewModel.changeStatus()
    }
}

#Preview {
    @Previewable  @State var userManager = UserManager()
    let container = try! ModelContainer(
        for: TaskItem.self,
        configurations: ModelConfiguration(isStoredInMemoryOnly: true)
    )
    
    let mockTask = TaskItem.mock
    container.mainContext.insert(mockTask)
    
    return TabView {
        NavigationStack {
            TaskDetailView(task: mockTask, context: container.mainContext)
        }
    }
    .modelContainer(container)
}



