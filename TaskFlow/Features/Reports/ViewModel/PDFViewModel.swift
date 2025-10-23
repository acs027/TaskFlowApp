//
//  PDFViewModel.swift
//  TaskFlow
//
//  Created by ali cihan on 24.10.2025.
//

import Foundation

@Observable
class PDFViewModel {
    
    var pdfFiles: [URL] = []
    
    init() {
        loadPdfFiles()
    }
    
    func loadPdfFiles() {
        let directory = URL.documentsDirectory
        
        do {
           let fileURLs = try FileManager.default.contentsOfDirectory(at: directory, includingPropertiesForKeys: nil)
            self.pdfFiles = fileURLs.filter { $0.pathExtension == "pdf" }
            
        } catch {
            print("error getting pdf file urls: \(error)")
        }
    }
    
    func delete(_ fileURL: URL) {
        do {
           try FileManager.default.removeItem(at: fileURL)
            loadPdfFiles()
        } catch {
            print("error deleting pdf: \(error)")
        }
    }
}
