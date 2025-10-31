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
    @Environment(\.isNetworkConnected) var isNetworkConnected
    @Environment(\.connectionType) var connectionType
    @Binding var selectedTab: TaskFlowTabBar.Tab
    @State var viewModel: ViewModel?
    @AppStorage("manualSync") var manualSyncRawValue: String = ManualSync.off.rawValue
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(uiColor: UIColor.systemGroupedBackground)
                    .ignoresSafeArea()
                VStack {
                    summarySection
                    shortcutsSection
                    
                    Spacer()
                }
                
                if let viewModel, viewModel.isSyncing {
                    SyncLoadingView()
                }
            }
            .navigationTitle("Dashboard")
            .toolbar {
                if manualSyncRawValue == "On", let viewModel {
                    ToolbarItem {
                        Button("Sync", systemImage: "arrow.trianglehead.2.clockwise.rotate.90.circle") {
                            Task {
                                await viewModel.sync()
                            }
                        }
                        .tint(isNetworkConnected ?? false ? .none : .red)
                        .disabled(isNetworkConnected != true)
                    }
                }
            }
        }
        .onAppear {
            if viewModel == nil {
                viewModel = ViewModel(context: context)
            }
        }
        .onChange(of: selectedTab) { oldValue, newValue in
            if case .dashboard = newValue,
               let viewModel {
                viewModel.fetchTaskCounts()
            }
        }
        .onChange(of: connectionType, { oldValue, newValue in
            if let viewModel {
                Task {
                    await viewModel.checkForSync(for: newValue, isConnected: isNetworkConnected)
                }
            }
        })
        .task {
            if let viewModel {
                await viewModel.checkForSync(for: connectionType, isConnected: isNetworkConnected)
            }
        }
    }
    
    @ViewBuilder
    private var summarySection: some View {
        if let viewModel {
            VStack {
                HStack {
                    BoxLabel(title: "Waiting", count: viewModel.count(for: .planned))
                    BoxLabel(title: "Ongoing", count: viewModel.count(for: .ongoing))
                    BoxLabel(title: "Completed", count: viewModel.count(for: .completed))
                }
                .frame(height: 100)
                .padding(.horizontal)
            }
        }
    }
    
    private var shortcutsSection: some View {
        VStack {
            Text("Shortcuts")
                .bold()
                .font(.headline)
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
        .padding(.vertical)
    }
}

#Preview {
    @Previewable @State var selectedTab: TaskFlowTabBar.Tab = .dashboard
    DashboardView(selectedTab: $selectedTab)
}



