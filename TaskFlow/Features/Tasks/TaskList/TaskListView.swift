//
//  TaskListView.swift
//  TaskFlow
//
//  Created by ali cihan on 19.10.2025.
//

import SwiftUI

struct TaskListView: View {
    @State var viewModel: ViewModel = ViewModel()
    @State var isCreating: Bool = false
    @Namespace var transition
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.tasks, id:\.id) { task in
                    NavigationLink {
                        //TODO: TaskDetailView
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
                        //TODO: Navigation to the creation
                        isCreating.toggle()
                    }
                }
                .matchedTransitionSource(id: "sheet", in: transition)
            }
            .navigationDestination(isPresented: $isCreating) {
                TaskCreationView()
                    .navigationTransition(.zoom(sourceID: "sheet", in: transition))
            }
        }
        .onAppear {
            viewModel.loadMockData()
        }
    }
}

#Preview {
    TaskListView()
}


