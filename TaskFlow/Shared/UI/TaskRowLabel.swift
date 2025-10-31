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
                        .bold()
                        .font(.caption)
                    Text(task.title)
                    Spacer()
                }
                .padding()
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .gridCellColumns(3)
            }
            GridRow {
                VStack {
                    Text("Assigned to:")
                        .bold()
                        .font(.caption)
                    Text(task.assignedUnit)
                }
                VStack() {
                    Image(systemName: "target")
                        .bold()
                        .frame(width: 5, height: 5)
                        .foregroundStyle(task.taskState.color)
                    Text(task.taskState.rawValue)
                        .font(.caption)
                }
                VStack {
                    Text("Deadline:")
                        .bold()
                        .font(.caption)
                    Text(task.deadline, style: .relative)
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.backgroundColor(for: task))
        )
    }
}
