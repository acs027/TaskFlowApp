//
//  TaskCreationView.swift
//  TaskFlow
//
//  Created by ali cihan on 19.10.2025.
//

import SwiftUI
import CoreLocation

struct TaskCreationView: View {
    @State private var viewModel: ViewModel = ViewModel()
    @State var isMapExpanded: Bool = false
    @State private var mapCoordinate: CLLocationCoordinate2D? = nil
    
    var body: some View {
        NavigationStack {
            
            ZStack(alignment: .bottom) {
                Form {
                    Section("Title*") {
                        TextField("Title*", text: $viewModel.title)
                    }
                    Section {
                        // Tap to expand/collapse
                           Button(action: { isMapExpanded.toggle() }) {
                               HStack {
                                   Text("Select Location")
                                   Spacer()
                                   Image(systemName: isMapExpanded ? "chevron.up" : "chevron.down")
                               }
                           }

                           // Map appears when expanded
                           if isMapExpanded {
                               MapView(selectedCoordinate: $mapCoordinate)
                                   .frame(height: 250)
                                   .cornerRadius(10)
                                   .padding(.vertical, 4)
                           }
                    }
                    
                    Section("Deadline*") {
                        DatePicker("Deadline", selection: $viewModel.deadline, in: .now...)
                            .datePickerStyle(.compact)
                        
                    }
                    Section("Assigned person/team*") {
                        TextField("Person/Team", text: $viewModel.assignedUnit)
                    }
                    
                    Section("Additional Infos") {
                        Picker("Priority", selection: $viewModel.priority) {
                            ForEach(Priority.allCases, id:\.id) { priority in
                                Text(priority.rawValue)
                                    .tag(priority.id)
                            }
                        }
                        .pickerStyle(.segmented)
                        //                    TextField("Priority", text: $title)
                        TextField("Category", text: $viewModel.category)
                        TextField("Control List", text: $viewModel.controlList)
                        TextField("Description", text: $viewModel.description)
                    }
                        
                }
                Button("Save") {
                    
                }
                .buttonStyle(.bordered)
                .buttonSizing(.flexible)
                .frame(maxWidth: .infinity)
                .padding()
            }
            .navigationTitle("Create a Task")
        }
    }
}

#Preview {
    TaskCreationView()
}
