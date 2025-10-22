//
//  TaskStateLabel.swift
//  TaskFlow
//
//  Created by ali cihan on 20.10.2025.
//

import SwiftUI

struct TaskStateLabel: View {
    let title: String
    let background: Color
    var body: some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(background)
            .frame(height: 50)
            .overlay {
                Text(title)
            }
    }
}
