//
//  UserManager.swift
//  TaskFlow
//
//  Created by ali cihan on 22.10.2025.
//

import Foundation

@Observable
class UserManager {
    enum UserRole: String, Codable {
        case admin, guest
    }
    var role: UserRole = .admin
}
