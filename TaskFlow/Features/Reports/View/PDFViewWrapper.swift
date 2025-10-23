//
//  PDFViewWrapper.swift
//  TaskFlow
//
//  Created by ali cihan on 24.10.2025.
//

import SwiftUI
import PDFKit


struct PDFViewWrapper: UIViewRepresentable {
    
    let fileURL: URL
    
    func makeUIView(context: Context) -> PDFView {
        let pdfView = PDFView()
        pdfView.autoScales = true
        return pdfView
    }
    
    func updateUIView(_ uiView: PDFView, context: Context) {
        uiView.document = PDFDocument(url: fileURL)
    }
}
