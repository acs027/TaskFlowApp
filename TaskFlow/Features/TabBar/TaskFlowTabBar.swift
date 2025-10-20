//
//  TaskFlowTabBar.swift
//  TaskFlow
//
//  Created by ali cihan on 20.10.2025.
//

import SwiftUI

struct TaskFlowTabBar: View {
    @State var selectedTab: Tab = .dashboard
    
    enum Tab {
           case dashboard
           case tasks
           case locations
           case reports
           case settings
       }
    
    var body: some View {
        TabView(selection: $selectedTab) {
                    
                    DashboardView()
                        .tabItem {
                            Label("Dashboard", systemImage: "house.fill")
                        }
                        .tag(Tab.dashboard)
                    
                    TaskListView()
                        .tabItem {
                            Label("Tasks", systemImage: "checklist")
                        }
                        .tag(Tab.tasks)
                    
            Color.clear
                        .tabItem {
                            Label("Locations", systemImage: "mappin.and.ellipse")
                        }
                        .tag(Tab.locations)
                    
            Color.clear
                        .tabItem {
                            Label("Reports", systemImage: "doc.text.magnifyingglass")
                        }
                        .tag(Tab.reports)
                    
            Color.clear
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
