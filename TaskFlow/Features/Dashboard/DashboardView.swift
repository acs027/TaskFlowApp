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
    @Query var tasks: [TaskItem]
    @Binding var selectedTab: TaskFlowTabBar.Tab
    @State var viewModel: ViewModel = ViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                Section{
                    VStack {
                        HStack {
                            BoxLabel(title: "Waiting", count: viewModel.itemCount(for: .initial, context: context))
                            BoxLabel(title: "Ongoing", count: viewModel.itemCount(for: .workInProgress, context: context))
                            BoxLabel(title: "Complete", count: viewModel.itemCount(for: .done, context: context))
                        }
                        .frame(height: 100)
                        .padding(.horizontal)
                    }
                }
                
                Section("Shortcuts") {
                    VStack {
                        HStack {
                            BoxLabel(title: "Tasks")
                                .onTapGesture {
                                    selectedTab = .tasks
                                }
                            BoxLabel(title: "My Locations")
                                .onTapGesture {
                                    selectedTab = .locations
                                }
                        }
                        .frame(height: 150)
                        .padding(.horizontal)
                        HStack {
                            BoxLabel(title: "My reports")
                                .onTapGesture {
                                    selectedTab = .reports
                                }
                            BoxLabel(title: "Settings")
                                .onTapGesture {
                                    selectedTab = .settings
                                }
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
    @Previewable @State var selectedTab: TaskFlowTabBar.Tab = .dashboard
    DashboardView(selectedTab: $selectedTab)
}



