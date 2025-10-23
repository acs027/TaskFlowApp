//
//  PDFDetailView.swift
//  TaskFlow
//
//  Created by ali cihan on 24.10.2025.
//

import SwiftUI

struct PDFDetailView: View {
    
    let fileURL: URL
    @Bindable var pdfViewModel: PDFViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        PDFViewWrapper(fileURL: fileURL)
            .toolbar {
                Button {
                    pdfViewModel.delete(fileURL)
                    dismiss()
                } label: {
                    Label("Delete", systemImage: "trash")
                }
                
                ShareLink(item: fileURL)
            }
            .navigationTitle(fileURL.lastPathComponent)
            .navigationBarTitleDisplayMode(.inline)
    }
}
