//
//  TodoEditView.swift
//  TaskFlow
//
//  Created by ali cihan on 21.10.2025.
//

import SwiftUI
import SwiftData

extension TaskDetailView {
    struct TodoEditView: View {
        @Environment(\.dismiss) var dismiss
        @Binding var viewModel: ViewModel
        
        var body: some View {
            VStack {
                TextEditor(text: $viewModel.task.todoList)
                        .border(.secondary)
                        .padding()
                        .padding()
                .navigationTitle("Editing todo")
                Spacer()
                Button("Save") {
                    viewModel.save()
                    dismiss()
                }
            }
        }
    }
}
