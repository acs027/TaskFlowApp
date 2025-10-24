//
//  TaskListView.swift
//  TaskFlow
//
//  Created by ali cihan on 19.10.2025.
//

import SwiftUI
import SwiftData

struct TaskListView: View {
    @Environment(\.modelContext) var context
    @Environment(UserManager.self) var userManager
    @State var viewModel: ViewModel
    @State var isCreating: Bool = false
    @Namespace var transition
    
    init(context: ModelContext) {
        let viewModel = ViewModel(context: context)
        _viewModel = State(initialValue: viewModel)
    }
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.tasks, id:\.id) { task in
                    NavigationLink(destination: TaskDetailView(task: task, context: context)) {
                        HStack {
                            Text(task.title)
                            Spacer()
                            Text(task.assignedUnit)
                            Spacer()
                            Text(task.deadline, style: .relative)
                        }
                    }
                    .listRowBackground(Color.backgroundColor(for: task))
                }
            }
            .navigationTitle("Task List")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    if userManager.role == .admin {
                        Button("Add a task", systemImage: "plus") {
                            isCreating.toggle()
                        }
                        .matchedTransitionSource(id: "sheet", in: transition)
                    }
                }
            }
            
            .navigationDestination(isPresented: $isCreating) {
                TaskCreationView(context: context)
                    .navigationTransition(.zoom(sourceID: "sheet", in: transition))
            }
        }
        .onAppear {
            viewModel.fetchData()
        }
//        .task {
//            await viewModel.sync()
//        }
    }
    
}

#Preview {
    @Previewable @Environment(\.modelContext) var context
    TaskListView(context: context)
}


