//
//  TaskStateLabel.swift
//  TaskFlow
//
//  Created by ali cihan on 20.10.2025.
//

import SwiftUI

struct TaskStateLabel: View {
    let taskState: TaskState
    let currentState: TaskState
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(.green)
                .frame(height: 50)
                .overlay {
                    Text(taskState.rawValue)
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                }
            if taskState < currentState || currentState == .completed {
                RoundedRectangle(cornerRadius: 20).fill(.blue.opacity(0.4)).frame(height: 50)
                Image(systemName: "checkmark.seal")
                    .foregroundStyle(.yellow)
                    .font(.largeTitle)
            }
        }
    }
}
