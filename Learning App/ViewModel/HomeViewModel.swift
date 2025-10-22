//
//  HomePage.swift
//  Learning App
//
//  Created by rawan alkhaldi  on 30/04/1447 AH.
//

import SwiftUI

@Observable
class LearningViewModel {
    var goal = LearningGoal()
    var isGoalTextFocused = false

    func selectPeriod(_ period: Period) {
        goal.selectedPeriod = period
    }
}
