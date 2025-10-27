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
        let page = uiView.document?.page(at: 0)
//        let page = pdfDocument?.page(at: 0)

        // Create signature annotation
        let signature = PDFAnnotation(bounds: CGRect(x: 100, y: 100, width: 200, height: 50), forType: .widget, withProperties: nil)
        signature.widgetFieldType = .signature
        page?.addAnnotation(signature)
    }
}
