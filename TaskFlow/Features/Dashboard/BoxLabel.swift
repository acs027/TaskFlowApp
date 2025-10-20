//
//  BoxLabel.swift
//  TaskFlow
//
//  Created by ali cihan on 20.10.2025.
//

import SwiftUI

struct BoxLabel: View {
    let title: String
    var count: Int? = nil
    var body: some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(Color(uiColor: UIColor.systemGroupedBackground))
            .overlay(alignment: .topLeading) {
                Text(title)
                    .padding()
            }
            .overlay(alignment: .center) {
                if let count {
                    Text("\(count)")
                }
            }
    }
}
