//
//  UserManager.swift
//  TaskFlow
//
//  Created by ali cihan on 22.10.2025.
//

import Foundation

struct UserManager {
    static var role: UserRole = UserRole(rawValue: UserDefaults.standard.string(forKey: "userRole") ?? UserRole.technician.rawValue) ?? .technician
}
