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
    @State private var isShowingLocationPicker = false
    @State private var mapCoordinate: CLLocationCoordinate2D? = nil
    @AppStorage("notificationsEnabled") var notificationsEnabled: Bool = false
    let onSave: () -> Void
    
    init(context: ModelContext, onSave: @escaping () -> Void) {
        let viewModel = ViewModel(context: context)
        _viewModel = State(initialValue: viewModel)
        self.onSave = onSave
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
          
        }
        .safeAreaInset(edge: .bottom, content: {
            saveButton
        })
        .alert(viewModel.errorMessage, isPresented: $viewModel.isAlertShowing) { }
        .navigationTitle("Create a Task")
        .onChange(of: mapCoordinate != nil) { oldValue, newValue in
            if let coordinate = mapCoordinate {
                let location = Location(name: "User", latitude: coordinate.latitude, longitude: coordinate.longitude)
                viewModel.location = location
            }
        }
        .sheet(isPresented: $isShowingLocationPicker) {
                  MapSearchView(selectedCoordinate: $mapCoordinate)
              }
    }
    
    private var locationSection: some View {
        Section("Location*") {
            Button {
                isShowingLocationPicker = true
            } label: {
                HStack {
                    Text("Select Location")
                    Spacer()
                    Image(systemName: "map.fill")
                }
            }
            
            if let coordinate = mapCoordinate {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Latitude: \(coordinate.latitude, specifier: "%.5f")")
                    Text("Longitude: \(coordinate.longitude, specifier: "%.5f")")
                }
                .font(.footnote)
                .foregroundColor(.secondary)
                .padding(.top, 4)
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
//            TextField("Category", text: $viewModel.category)
//            TextField("Control List", text: $viewModel.checkList)
            TextField("Description", text: $viewModel.description)
        }
    }
    
    private var saveButton: some View {
        Button("Save") {
            viewModel.saveTask(isNotificationOn: notificationsEnabled) {
                onSave()
            }
        }
        .buttonStyle(.bordered)
        .buttonSizing(.flexible)
        .frame(maxWidth: .infinity)
        .padding()
    }
}

#Preview {
    @Previewable @Environment(\.modelContext) var context
    TaskCreationView(context: context, onSave: { })
}
