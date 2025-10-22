//
//  TaskCreationView.swift
//  TaskFlow
//
//  Created by ali cihan on 19.10.2025.
//

import SwiftUI
import CoreLocation
import SwiftData

struct TaskCreationView: View {
    @State private var viewModel: ViewModel
    @State var isMapExpanded: Bool = false
    @State private var mapCoordinate: CLLocationCoordinate2D? = nil
    
    init(context: ModelContext) {
        let viewModel = ViewModel(context: context)
        _viewModel = State(initialValue: viewModel)
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Form {
                Section("Title*") {
                    TextField("Title*", text: $viewModel.title)
                }
                locationSection
                
                Section("Deadline*") {
                    DatePicker("Deadline", selection: $viewModel.deadline, in: .now...)
                        .datePickerStyle(.compact)
                    
                }
                Section("Assigned person/team*") {
                    TextField("Person/Team", text: $viewModel.assignedUnit)
                }
                
                additionalSection
                
            }
          saveButton
        }
        .alert(viewModel.errorMessage, isPresented: $viewModel.isAlertShowing) { }
        .navigationTitle("Create a Task")
        .onChange(of: mapCoordinate != nil) { oldValue, newValue in
            if let coordinate = mapCoordinate {
                let location = Location(name: "User", latitude: coordinate.latitude, longitude: coordinate.longitude)
                viewModel.location = location
            }
        }
    }
    
    private var locationSection: some View {
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
    }
    
    private var additionalSection: some View {
        Section("Additional Infos") {
            Picker("Priority", selection: $viewModel.priority) {
                ForEach(Priority.allCases, id:\.id) { priority in
                    Text(priority.rawValue)
                        .tag(priority)
                }
            }
            .pickerStyle(.segmented)
            //                    TextField("Priority", text: $title)
            TextField("Category", text: $viewModel.category)
            TextField("Control List", text: $viewModel.controlList)
            TextField("Description", text: $viewModel.description)
        }
    }
    
    private var saveButton: some View {
        Button("Save") {
            viewModel.saveTask()
        }
        .buttonStyle(.bordered)
        .buttonSizing(.flexible)
        .frame(maxWidth: .infinity)
        .padding()
    }
}

#Preview {
    @Previewable @Environment(\.modelContext) var context
    TaskCreationView(context: context)
}
