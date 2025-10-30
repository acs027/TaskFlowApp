//
//  SupabaseManager.swift
//  TaskFlow
//
//  Created by ali cihan on 25.10.2025.
//

import Foundation
import Supabase
import FirebaseAuth

@MainActor
final class SupabaseManager {
    static let shared = SupabaseManager()
    private let fileManager = FileManager.default
    private let documentsURL: URL
//    private let bucketName = "tasksContent"
    private let bucketName = "taskbucket"
    
    private var activeUploads = Set<String>()
    private let uploadLock = NSLock()
    
    private var activeDownloads = Set<String>()
    private let downloadLock = NSLock()
    
    struct MissingFirebaseTokenError: Error {}
    
    let client = SupabaseClient(
        supabaseURL: URL(string: "https://mxwzgvgjsrtahornytrq.supabase.co")!,
        supabaseKey: "sb_publishable_702drFpaIILFdoC7i3JAMw_iJ7oGnkJ", //Public
        options: SupabaseClientOptions(
            auth: SupabaseClientOptions.AuthOptions(accessToken: {
                guard let token = try await Auth.auth().currentUser?.getIDToken() else {
                    throw MissingFirebaseTokenError()
                }
                return token
            })
        )
    )
    
    
    private init() {
        self.documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    
    // MARK: - Main Sync Entry Point
    func syncMedia(for workItems: [WorkItem]) async {
        for workItem in workItems {
            await ensureLocalAndRemoteSync(for: workItem)
        }
    }
    
    // MARK: - Sync Logic for One WorkItem
    private func ensureLocalAndRemoteSync(for workItem: WorkItem) async {
        guard let url = workItem.mediaURL else { return }
        
        let localURL = documentsURL.appendingPathComponent(url.lastPathComponent)
        let fileExistsLocally = fileManager.fileExists(atPath: localURL.path)
        
        if !fileExistsLocally {
            // Try to download from Supabase
            await downloadIfAvailable(for: workItem, to: localURL)
        } else {
            // Ensure it's uploaded to Supabase
            await uploadIfMissing(for: workItem, from: localURL)
        }
        
        // Update WorkItem URL if necessary
        if workItem.mediaURL != localURL {
            workItem.mediaURL = localURL
        }
    }
    
}

extension SupabaseManager {
    private func downloadIfAvailable(for workItem: WorkItem, to destination: URL) async {
        guard let fileName = workItem.mediaURL?.lastPathComponent else { return }
        
        downloadLock.lock()
        if activeDownloads.contains(fileName) {
            downloadLock.unlock()
            print("⚠️ Skipping duplicate upload for \(fileName)")
            return
        }
        activeDownloads.insert(fileName)
        downloadLock.unlock()
        // ---------------------------------
        
        defer {
            downloadLock.lock()
            activeDownloads.remove(fileName)
            downloadLock.unlock()
        }
        
        do {
            let data = try await client.storage.from(bucketName).download(path: fileName)
            try data.write(to: destination)
            print("✅ Downloaded \(fileName) to \(destination.lastPathComponent)")
        } catch {
            print("⚠️ Could not download \(fileName): \(error)")
        }
    }
    
    private func uploadIfMissing(for workItem: WorkItem, from localURL: URL) async {
        guard let fileName = workItem.mediaURL?.lastPathComponent else { return }
        
        // --- Prevent duplicate uploads ---
            uploadLock.lock()
            if activeUploads.contains(fileName) {
                uploadLock.unlock()
                print("⚠️ Skipping duplicate upload for \(fileName)")
                return
            }
            activeUploads.insert(fileName)
            uploadLock.unlock()
            // ---------------------------------
            
            defer {
                uploadLock.lock()
                activeUploads.remove(fileName)
                uploadLock.unlock()
            }
        
        do {
            // Check if file exists on Supabase
            let list = try await client.storage.from(bucketName).list()
            if !list.contains(where: { $0.name == fileName }) {
                let data = try Data(contentsOf: localURL)
                try await client.storage
                    .from(bucketName)
                    .upload(fileName, data: data, options: FileOptions(cacheControl: "3600", upsert: false))
                print("☁️ Uploaded \(fileName) to Supabase.")
            } else {
                print("🔹 \(fileName) already exists in Supabase.")
            }
        } catch {
            print("❌ Failed to upload \(fileName): \(error)")
        }
    }
}

