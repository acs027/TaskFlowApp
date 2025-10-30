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
        @State var textfield: String = ""
        
        var body: some View {
            VStack {
                SheetControlButtons(buttonTitle: "Save") {
                    viewModel.task.taskDescription = textfield
                    viewModel.save()
                    dismiss()
                }
                TextEditor(text: $textfield)
                        .border(.secondary)
                        .padding()
                        .padding()
                .navigationTitle("Editing todo")
                Spacer()
            }
            .onAppear {
                textfield = viewModel.task.taskDescription
            }
            .onDisappear {
                textfield = ""
            }
        }
    }
}
