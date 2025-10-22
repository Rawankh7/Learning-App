//
//  ActivityViewModel.swift
//  Learning App
//
//  Created by rawan alkhaldi  on 30/04/1447 AH.
//

import SwiftUI

/// 🧭 الـ ViewModel: يتحكم في منطق التفاعل (الأسبوع الحالي، اليوم المختار، التنقل).
@Observable
class ActivityViewModel {
    @ObservationIgnored
    private let calendar = Calendar.current
    
    /// اليوم المختار حاليًا
    var selectedDate: Date = Date()
    
    /// بداية الأسبوع الحالي
    var currentWeekStart: Date = Calendar.current.startOfWeek(for: Date())
    
    /// قائمة أيام الأسبوع الحالي
    var currentWeekDays: [ActivityDay] {
        (0..<7).compactMap { offset in
            if let day = calendar.date(byAdding: .day, value: offset, to: currentWeekStart) {
                return ActivityDay(date: day)
            }
            return nil
        }
    }
    
    /// تحريك الأسبوع للأمام أو الخلف
    func moveWeek(by value: Int) {
        if let newWeek = calendar.date(byAdding: .weekOfYear, value: value, to: currentWeekStart) {
            currentWeekStart = calendar.startOfWeek(for: newWeek)
        }
    }
    
    /// تحديد يوم جديد
    func selectDay(_ day: Date) {
        selectedDate = day
    }
    
    /// مقارنة إذا كان اليوم هو المختار
    func isSelected(_ day: Date) -> Bool {
        calendar.isDate(day, inSameDayAs: selectedDate)
    }
}
