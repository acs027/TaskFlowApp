//
//  ReportListView.swift
//  TaskFlow
//
//  Created by ali cihan on 24.10.2025.
//

import SwiftUI

struct ReportListView: View {
    @State var viewModel = PDFViewModel()
    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.pdfFiles, id:\.absoluteString) { file in
                    NavigationLink(file.lastPathComponent) {
                        PDFDetailView(fileURL: file.absoluteURL, pdfViewModel: viewModel)
                    }
                }
            }
            .refreshable {
                viewModel.loadPdfFiles()
            }
            .navigationTitle("Reports")
        }
    }
}

#Preview {
    ReportListView()
}






