//
//  PDFContentView.swift
//  TaskFlow
//
//  Created by ali cihan on 24.10.2025.
//

import SwiftUI

struct PDFContentView: View {
    let task: TaskItem
    let a4Size = CGSize(width: 595.2, height: 841.8)
    
    var body: some View {
        VStack(spacing: 12) {
            Text(task.title)
                .font(.headline)
                .bold()
                .frame(alignment: .center)
            HStack(alignment: .top) {
                Text("Assigned unit/person : ")
                    .bold()
                    .frame(width: 150)
                Text(task.assignedUnit)
                Spacer()
            }
            HStack(alignment: .top) {
                Text("Description : ")
                    .bold()
                    .frame(width: 150)
                Text(task.taskDescription)
                Spacer()
            }
            HStack(alignment: .top) {
                Text("Document Date : ")
                    .bold()
                    .frame(width: 150)
                Text(Date(), style: .date)
                Spacer()
            }
            Spacer()
        }
        .padding()
        .frame(width: a4Size.width, height: a4Size.height)
    }
}

#Preview {
    PDFContentView(task: TaskItem.mock)
}
