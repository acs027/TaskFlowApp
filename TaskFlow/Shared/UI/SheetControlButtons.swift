//
//  SheetControlButtons.swift
//  TaskFlow
//
//  Created by ali cihan on 30.10.2025.
//

import SwiftUI

struct SheetControlButtons: View {
    @Environment(\.dismiss) var dismiss
    var buttonTitle: String = "Done"
    var function: (() -> Void)? = nil
    
    
    var body: some View {
        HStack {
            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark.circle")
                    .resizable()
                    .frame(width: 40, height: 40)
                    
            }
            .glassEffect(.regular.interactive())
            Spacer()
            Button(buttonTitle) {
                if let function {
                    function()
                } else {
                    dismiss()
                }
            }
            .padding()
            .frame(height: 50)
            .glassEffect(.regular.interactive())
        }
        .padding()
    }
}
