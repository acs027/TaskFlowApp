//
//  TaskCreationViewModel.swift
//  TaskFlow
//
//  Created by ali cihan on 19.10.2025.
//

import Foundation
import Observation

extension TaskCreationView {
    @Observable
    final class ViewModel {
        var title: String = ""
        var location: Location?
        var deadline: Date = .now
        var assignedUnit: String = ""
        
        var category: String = ""
        var priority: Priority?
        var controlList: String = ""
        var description: String = ""
    }
}
