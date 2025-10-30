//
//  TaskRowLabel.swift
//  TaskFlow
//
//  Created by ali cihan on 30.10.2025.
//

import SwiftUI

struct TaskRowLabel: View {
    let task: TaskItem
    
    var body: some View {
        Grid {
            GridRow {
                HStack {
                    Text("Title:")
                        .font(.caption)
                    Text(task.title)
                    Spacer()
                }
                .padding()
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .gridCellColumns(2)
            }
            GridRow {
                
                VStack {
                    Text("Assigned to:")
                        .font(.caption)
                    Text(task.assignedUnit)
                }
                VStack {
                    Text("Deadline:")
                        .font(.caption)
                    Text(task.deadline, style: .relative)
                }
            }
        }
    }
}
