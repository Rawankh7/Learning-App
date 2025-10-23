//
//  ActivityViewModel.swift
//  Learning App
//
//  Created by rawan alkhaldi on 30/04/1447 AH.
//

import SwiftUI

final class ActivityViewModel: ObservableObject {
    // MARK: - الخصائص المنشورة
    @Published var currentWeekStart: Date = Calendar.current.startOfWeek(for: Date())
    @Published var selectedDate: Date = Date()
    @Published var showCalendarPage = false
    @Published var showEditPage = false

    // MARK: - التنقل بين الصفحات
    enum Destination {
        case calendar, edit
    }

    func navigateTo(_ destination: Destination) {
        switch destination {
        case .calendar:
            showCalendarPage = true
        case .edit:
            showEditPage = true
        }
    }

    // MARK: - تحويل الأسبوع
    func moveWeek(by value: Int) {
        if let newWeek = Calendar.current.date(byAdding: .weekOfYear, value: value, to: currentWeekStart) {
            currentWeekStart = Calendar.current.startOfWeek(for: newWeek)
        }
    }

    // MARK: - تحديد يوم
    func selectDay(_ date: Date) {
        selectedDate = date
    }

    // MARK: - جلب أيام الأسبوع الحالية
    var currentWeekDays: [ActivityDay] {
        (0..<7).compactMap { offset in
            guard let day = Calendar.current.date(byAdding: .day, value: offset, to: currentWeekStart) else { return nil }
            return ActivityDay(date: day)
        }
    }

    // MARK: - التحقق من اليوم المحدد
    func isSelected(_ date: Date) -> Bool {
        Calendar.current.isDate(date, inSameDayAs: selectedDate)
    }
}
