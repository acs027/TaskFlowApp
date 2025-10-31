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
    @Environment(\.dismiss) var dismiss
    @State var viewModel: ViewModel
    @State var isEditingTodo: Bool = false
    @State var isEditingReview: Bool = false
    @State var isEditingOngoingContent: Bool = false
    @State var isDeletingTask: Bool = false
    @AppStorage("userRole") var userRoleRawValue: String = UserRole.technician.rawValue
    
    let onDelete: () -> Void
    
    init(task: TaskItem, context: ModelContext, onDelete: @escaping () -> Void) {
        self.viewModel = ViewModel(task: task, context: context)
        self.onDelete = onDelete
    }
    
    var body: some View {
        Form {
            taskState
            todoSection
            ongoingSection
            reviewSection
            completedSection
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
        .navigationTitle(viewModel.task.title)
        .alert(viewModel.errorMessage ?? "Error", isPresented: Binding(get: {
            viewModel.errorMessage != nil
        }, set: { _ in
            viewModel.errorMessage = nil
        })) {
            Text("OK")
        }
        .fullScreenCover(isPresented: Binding(get: {
            viewModel.fullscreenImageURL != nil
        }, set: { _ in
            viewModel.fullscreenImageURL = nil
        }), content: {
            ZStack {
                Color.black.ignoresSafeArea()
                AsyncImage(url: viewModel.fullscreenImageURL) { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .onTapGesture { viewModel.fullscreenImageURL = nil }
                } placeholder: {
                    ProgressView().tint(.white)
                }
            }
        })
        .fullScreenCover(isPresented: Binding(get: {
            viewModel.fullscreenVideoURL != nil
        }, set: { _ in
            viewModel.fullscreenVideoURL = nil
        }), content: {
            if let url = viewModel.fullscreenVideoURL {
                VStack {
                    SheetControlButtons()
                    VideoPlayerView(player: AVPlayer(url: url), isFullscreen: true)
                }
            }
        })
        .toolbar {
            if userRoleRawValue == UserRole.admin.rawValue {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Delete", role: .destructive) {
                        isDeletingTask.toggle()
                    }
                }
            }
        }
        .alert("Are you sure about to deleting this Task", isPresented: $isDeletingTask) {
            Button("OK", role: .destructive) {
                onDelete()
                dismiss()
            }
            Button("Cancel", role: .cancel) {
                
            }
        }
    }
    
    private var taskState: some View {
        HStack {
            ForEach(TaskState.allCases, id:\.id) { state in
                if state != .completed {
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
                if userRoleRawValue == UserRole.admin.rawValue {
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
                    Text("Edit")
                        .foregroundStyle(.blue)
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    isEditingOngoingContent.toggle()
                }
                Divider()
                if !viewModel.task.inProgressContent.isEmpty {
                    ForEach(viewModel.task.inProgressContent, id:\.id) { media in
                        switch media.mediaType {
                        case .image:
                            AsyncImage(url: media.mediaURL) { image in
                                image.resizable()
                                    .aspectRatio(16/9, contentMode: .fit)
                                    .onTapGesture {
                                        viewModel.fullscreenImageURL = media.mediaURL
                                    }
                            } placeholder: {
                                Color.blue
                                    .aspectRatio(16/9, contentMode: .fit)
                            }
                           
                        case .text:
                            Text(media.text ?? "")
                        case .video:
                            VStack {
                                if let url = media.mediaURL {
                                    Button("Fullscreen", role: .confirm) {
                                            viewModel.fullscreenVideoURL = url
                                        
                                    }
                                    VideoPlayerView(player: AVPlayer(url: url))
                                }
                            }
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(.ultraThinMaterial)
                            )
                            
                        }
                    }
                } else {
                    Text("Task media, notes")
                        .font(.caption)
                        .opacity(0.5)
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
                if userRoleRawValue == UserRole.admin.rawValue {
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
    
    @ViewBuilder
    private var completedSection: some View {
        if viewModel.task.taskState == .completed {
                Section {
                    Text(TaskState.completed.rawValue)
                        .bold()
                        .frame(height: 50)
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
            TaskDetailView(task: mockTask, context: container.mainContext) {
                
            }
        }
    }
    .modelContainer(container)
}



