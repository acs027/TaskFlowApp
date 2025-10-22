//
//  ChecklistEditView.swift
//  TaskFlow
//
//  Created by ali cihan on 21.10.2025.
//

import SwiftUI

extension TaskDetailView {
    struct ChecklistEditView: View {
        @State var isAddingItem: Bool = false
        @State var itemTitle: String = ""
        @Binding var viewModel: ViewModel
        
        var body: some View {
            ZStack(alignment: .bottomTrailing) {
                List {
                    Text("Checklist")
                    ForEach(viewModel.task.checklist, id:\.id) { item in
                        Toggle(isOn: toggleBinding(item: item)) {
                            Text(item.title)
                        }
                        .swipeActions(edge: .trailing, allowsFullSwipe: true, content: {
                            Button(role: .destructive) {
                                deleteCheckListItem(id: item.id)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        })
                    }
                }
                Button {
                    isAddingItem.toggle()
                } label: {
                    Label("Add a check", systemImage: "plus")
                        .labelStyle(.iconOnly)
                        .frame(width: 50, height: 50)
                }
                .glassEffect()
                .padding()
                
                if viewModel.processState == .loading {
                    ProgressView()
                }
            }
            .navigationTitle("Edit Checklist")
            .alert("Add a checklist row", isPresented: $isAddingItem) {
                TextField("Enter checkist row", text: $itemTitle)
                Button("Add", action: addCheckListItem)
                Button(role: .cancel) { }
            } message: {
                Text("TODO")
            }
        }
        
        private func toggleBinding(item: ChecklistItem) -> Binding<Bool> {
            Binding(
                get: { item.isChecked },
                set: { newValue in
                    if let index = viewModel.task.checklist.firstIndex(where: { $0.id == item.id }) {
                        viewModel.task.checklist[index].isChecked = newValue
                    }
                }
            )
        }
        
        private func deleteCheckListItem(id: UUID) {
            viewModel.deleteCheckListItem(id: id)
        }
        
        private func addCheckListItem() {
            let title = itemTitle
            itemTitle = ""
            viewModel.addCheckListItem(for: title)
        }
    }
}

//#Preview {
//    @Previewable @State var checklist: [ChecklistItem] = []
//    ChecklistEditView(checklist: $checklist)
//}
