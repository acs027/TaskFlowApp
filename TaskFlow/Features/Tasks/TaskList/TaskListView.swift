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
                    NavigationLink {
                        TaskDetailView(task: task)
                    }
                    label: {
                        HStack {
                            Text(task.title)
                            Spacer()
                            Text(task.assignedUnit)
                            Spacer()
                            Text(task.deadline, style: .relative)
                        }
                    }
                }
            }
            .navigationTitle("Task List")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Add a task", systemImage: "plus") {
                        isCreating.toggle()
                    }
                    .matchedTransitionSource(id: "sheet", in: transition)
                }
                
            }
            .navigationDestination(isPresented: $isCreating) {
                TaskCreationView(context: context)
                    .navigationTransition(.zoom(sourceID: "sheet", in: transition))
            }
        }
        .onAppear {
            viewModel.loadMockData()
        }
    }
}

#Preview {
    @Previewable @Environment(\.modelContext) var context
    TaskListView(context: context)
}


