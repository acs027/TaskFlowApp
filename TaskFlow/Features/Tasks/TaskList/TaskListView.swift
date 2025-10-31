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
    @AppStorage("userRole") var userRoleRawValue: String = UserRole.technician.rawValue
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
                ForEach(viewModel.remainingTasks, id:\.id) { task in
                    NavigationLink(destination: TaskDetailView(task: task, context: context) {
                        viewModel.deleteTask(task: task)
                    }) {
                       TaskRowLabel(task: task)
                    }
                    .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                }
                
                Section("Completed") {
                    ForEach(viewModel.completedTasks, id:\.id) { task in
                        NavigationLink(destination: TaskDetailView(task: task, context: context) {
                            viewModel.deleteTask(task: task)
                        }) {
                           TaskRowLabel(task: task)
                        }
                        .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                    }
                }
            }
            .listStyle(.plain)
            .navigationTitle("Task List")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    if userRoleRawValue == UserRole.admin.rawValue {
                        Button("Add a task", systemImage: "plus") {
                            isCreating.toggle()
                        }
                        .matchedTransitionSource(id: "sheet", in: transition)
                    }
                }
                
                if userRoleRawValue == UserRole.developer.rawValue {
                    ToolbarItem(placement: .topBarLeading) {
                        Button("Insert Mock Data", systemImage: "plus") {
                            viewModel.insertMockData()
                        }
                    }
                }
            }
            
            .navigationDestination(isPresented: $isCreating) {
                TaskCreationView(context: context) {
                    viewModel.fetchData()
                    isCreating.toggle()
                }
                    .navigationTransition(.zoom(sourceID: "sheet", in: transition))
            }
        }
        .onAppear {
            viewModel.fetchData()
        }
    }
}

#Preview {
    @Previewable @Environment(\.modelContext) var context
    TaskListView(context: context)
}




