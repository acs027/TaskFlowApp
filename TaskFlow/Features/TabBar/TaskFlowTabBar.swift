//
//  TaskFlowTabBar.swift
//  TaskFlow
//
//  Created by ali cihan on 20.10.2025.
//

import SwiftUI

struct TaskFlowTabBar: View {
    @State var selectedTab: Tab = .dashboard
    @Environment(\.modelContext) var context
    
    enum Tab {
        case dashboard
        case tasks
        case locations
        case reports
        case settings
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            
            DashboardView(selectedTab: $selectedTab)
                .tabItem {
                    Label("Dashboard", systemImage: "house.fill")
                }
                .tag(Tab.dashboard)
            
            
            TaskListView(context: context)
                .tabItem {
                    Label("Tasks", systemImage: "checklist")
                }
                .tag(Tab.tasks)
            
            UserLocationView()
                .tabItem {
                    Label("Location", systemImage: "mappin.and.ellipse")
                }
                .tag(Tab.locations)
            
            
            ReportListView()
                .tabItem {
                    Label("Reports", systemImage: "doc.text.magnifyingglass")
                }
                .tag(Tab.reports)
            
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape.fill")
                }
                .tag(Tab.settings)
        }
        .tint(.accentColor)
    }
}

#Preview {
    TaskFlowTabBar()
}
