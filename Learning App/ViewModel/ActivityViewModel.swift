// ActivityViewModel.swift (يجب أن يكون في مجلد ViewModel)

import SwiftUI
// ملاحظة: struct ActivityDay و enum DayStatus و Calendar extension موجودة الآن في ملف Model منفصل.

final class ActivityViewModel: ObservableObject {
    
   // final class ActivityViewModel: ObservableObject {
        
        // MARK: - الخصائص
        @Published var currentWeekStart: Date = Calendar.current.startOfWeek(for: Date())
        @Published var selectedDate: Date = Date()
        @Published var showCalendarPage = false
        @Published var showEditPage = false
        @Published var showCompletePage = false   // ✅ needed for navigation to complete()
        @Published var showLearningGoalPage = false // ✅ NEW: navigate to LearningGoalView

        // MARK: - أنشطة المستخدم (الأهداف المشتركة)
        @Published var learnedStreak: Int = 0
        @Published var freezeCount: Int = 0
        @Published var points: Int = 0
        // DayStatus يتم الوصول إليها من ملف الـ Model
        @Published var dayStatuses: [Date: DayStatus] = [:]

        let maxFreezes = 2

        // MARK: - Navigation
        enum Destination { case calendar, edit }
        func navigateTo(_ destination: Destination) {
            switch destination {
            case .calendar: showCalendarPage = true
            case .edit: showEditPage = true
            }
        }

        // MARK: - الأسبوع
        func moveWeek(by value: Int) {
            if let newWeek = Calendar.current.date(byAdding: .weekOfYear, value: value, to: currentWeekStart) {
                currentWeekStart = Calendar.current.startOfWeek(for: newWeek)
            }
        }

        func selectDay(_ date: Date) {
            selectedDate = date
        }

        var currentWeekDays: [ActivityDay] {
            (0..<7).compactMap { offset in
                guard let day = Calendar.current.date(byAdding: .day, value: offset, to: currentWeekStart) else { return nil }
                return ActivityDay(date: day)
            }
        }

        func isSelected(_ date: Date) -> Bool {
            Calendar.current.isDate(date, inSameDayAs: selectedDate)
        }

        // MARK: - View Helpers (للتحقق من حالة زر التعلم)
        
        /// 🟢 المنطق الجديد: يحدد ما إذا كان الزر يجب أن يكون متاحاً للضغط.
        var canLogLearnedToday: Bool {
            let calendar = Calendar.current
            
            // 1. يجب أن يكون اليوم المحدد هو اليوم الحالي.
            guard calendar.isDateInToday(selectedDate) else {
                return false
            }
            
            // 2. يجب ألا يكون قد تم تسجيل أي نشاط (تعلم أو تجميد) لليوم الحالي.
            let status = dayStatuses[selectedDate]
            return status == nil || status == .none
        }
        
        func dayStatus(for date: Date) -> DayStatus {
            return dayStatuses[date] ?? .none
        }

        func dayColor(for date: Date) -> Color {
            return dayStatus(for: date).color
        }

        func dayOverlay(for date: Date) -> Color {
            return dayStatus(for: date).overlayColor
        }
        
        // MARK: - تسجيل اليوم
        func logLearned(for date: Date) {
            let calendar = Calendar.current

            // امنع التكرار لنفس اليوم (يمكنك إزالة هذا الشرط إذا أردت السماح بإعادة الضغط)
            guard calendar.isDateInToday(date) && (dayStatuses[date] == nil || dayStatuses[date] == .none) else {
                return
            }
            
            // ✅ اجعل التسلسل يصبح 7 مباشرة عند أول ضغط
            learnedStreak = 7
            points += 7
            dayStatuses[date] = .learned

            // ✅ افتح صفحة الإكمال فوراً عندما يكون التسلسل 7 بالضبط
            showCompletePage = (learnedStreak == 7)
        }

        func logFreezed(for date: Date) {
            guard freezeCount < maxFreezes else { return }
            freezeCount += 1
            dayStatuses[date] = .freezed
        }

        func canFreeze() -> Bool {
            let calendar = Calendar.current
            guard calendar.isDateInToday(selectedDate) else { return false }
            
            return freezeCount < maxFreezes && (dayStatuses[selectedDate] == nil || dayStatuses[selectedDate] == .none)
        }
    }// HOME PAGE
class LearningViewModel: ObservableObject {
    @Published var goal = LearningGoal()
    var isGoalTextFocused = false

    func selectPeriod(_ period: Period) {
        goal.selectedPeriod = period
    }
}

//CALENDAR

class CalendarViewModel: ObservableObject {
    @Published var months: [Date] = []
    @Published var currentMonthIndex: Int = 0
    
    private let calendar = Calendar.current
    
    init() {
        generateMonths()
        scrollToCurrentMonth()
    }
    
    private func generateMonths() {
        let currentDate = Date()
        guard
            let startDate = calendar.date(byAdding: .year, value: -100, to: currentDate),
            let endDate = calendar.date(byAdding: .year, value: 100, to: currentDate)
        else { return }
        
        var date = startDate
        var allMonths: [Date] = []
        while date <= endDate {
            allMonths.append(date)
            date = calendar.date(byAdding: .month, value: 1, to: date)!
        }
        self.months = allMonths
    }
    
    private func scrollToCurrentMonth() {
        if let index = months.firstIndex(where: { calendar.isDate($0, equalTo: Date(), toGranularity: .month) }) {
            currentMonthIndex = index
        }
    }
    
    func daysInMonth(for date: Date) -> [Date] {
        guard let range = calendar.range(of: .day, in: .month, for: date),
              let firstDay = calendar.date(from: calendar.dateComponents([.year, .month], from: date)) else {
            return []
        }
        return range.compactMap { calendar.date(byAdding: .day, value: $0 - 1, to: firstDay) }
    }
    
    func monthYearString(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: date)
    }
    
    func dayString(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter.string(from: date)
    }
    
    func isToday(_ date: Date) -> Bool {
        calendar.isDateInToday(date)
    }
    
    func dayOfWeekHeaders() -> [String] {
        ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    }
}

