//
//  DashboardView.swift
//  TaskFlow
//
//  Created by ali cihan on 20.10.2025.
//

import SwiftUI
import SwiftData

struct DashboardView: View {
    @Environment(\.modelContext) var context
    @Query var tasks: [Task]
    
    var body: some View {
        NavigationStack {
            VStack {
                Section{
                    VStack {
                        HStack {
                            BoxLabel(title: "Waiting", count: tasks.count(where: { $0.taskState == .initial}))
                            BoxLabel(title: "Ongoing", count: tasks.count(where: { $0.taskState == .workInProgress}))
                            BoxLabel(title: "Complete", count: tasks.count(where: { $0.taskState == .done }))
                        }
                        .frame(height: 100)
                        .padding(.horizontal)
                    }
                }
                
                Section("Shortcuts") {
                    VStack {
                        HStack {
                            BoxLabel(title: "Tasks")
                            BoxLabel(title: "My Locations")
                        }
                        .frame(height: 150)
                        .padding(.horizontal)
                        HStack {
                            BoxLabel(title: "My reports")
                            BoxLabel(title: "Settings")
                        }
                        .frame(height: 150)
                        .padding(.horizontal)
                    }
                }
                Spacer()
                Button("+ Create a task") {
                    
                }
                .buttonStyle(.borderedProminent)
            }
            .navigationTitle("Summary")
        }
    }
}

#Preview {
    DashboardView()
}



