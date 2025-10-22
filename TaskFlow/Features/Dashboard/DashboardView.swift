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
    @Environment(UserManager.self) var userManager
    @Binding var selectedTab: TaskFlowTabBar.Tab
    @State var viewModel: ViewModel = ViewModel()
    @State var isCreating: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack {
               summarySection
                shortcutsSection
             
                Spacer()
                if userManager.role == .admin {
                    createButton
                }
            }
            .navigationTitle("Summary")
            .navigationDestination(isPresented: $isCreating) {
                TaskCreationView(context: context)
            }
        }
        .onAppear {
            viewModel.fetchTaskCounts(context: context)
        }
    }
    
    private var summarySection: some View {
        Section{
            VStack {
                HStack {
                    BoxLabel(title: "Waiting", count: viewModel.count(for: .initial))
                             BoxLabel(title: "Ongoing", count: viewModel.count(for: .workInProgress))
                             BoxLabel(title: "Complete", count: viewModel.count(for: .done))
                }
                .frame(height: 100)
                .padding(.horizontal)
            }
        }
    }
    
    private var shortcutsSection: some View {
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
    }
    
    private var createButton: some View {
        Button("Create a task", systemImage: "plus") {
            isCreating.toggle()
        }
    }
}

#Preview {
    @Previewable @State var selectedTab: TaskFlowTabBar.Tab = .dashboard
    DashboardView(selectedTab: $selectedTab)
}



