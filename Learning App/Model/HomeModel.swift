//
//  HomePage.swift
//  Learning App
//
//  Created by rawan alkhaldi  on 30/04/1447 AH.
//

import Foundation

enum Period: String, CaseIterable, Identifiable {
    case week = "Week"
    case month = "Month"
    case year = "Year"

    var id: String { self.rawValue }
}

struct LearningGoal {
    var text: String = ""
    var selectedPeriod: Period? = nil
}
