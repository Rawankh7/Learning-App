// ActivityViewModel.swift (يجب أن يكون في مجلد ViewModel)

// ActivityViewModel.swift (الملف الموحد للـ ViewModels)

import SwiftUI
import Combine

// ⚠️ ملاحظة: يجب أن تكون struct ActivityDay, enum DayStatus, و extension Calendar
// موجودة في ملفات Model منفصلة مثل Calendar.swift أو ActivityData.swift.

// MARK: - Activity ViewModel (التحكم في الأهداف والأسبوع)

final class ActivityViewModel: ObservableObject {
    
    // MARK: - الخصائص
    @Published var currentWeekStart: Date = Calendar.current.startOfWeek(for: Date())
    @Published var selectedDate: Date = Date()
    @Published var showCalendarPage = false
    @Published var showEditPage = false
    
    // ✅ الخاصية الجديدة للتحكم في ظهور صفحة الإكمال
    @Published var showCompletePage = false

    // ✅ مفقودة سابقًا: لفتح صفحة "LearningGoalView"
    @Published var showcomplete = false

    // MARK: - أنشطة المستخدم (الأهداف المشتركة)
    @Published var learnedStreak: Int = 0
    @Published var freezeCount: Int = 0
    @Published var points: Int = 0
    @Published var dayStatuses: [Date: DayStatus] = [:]

    let maxFreezes = 2
    
    // MARK: - Goal Completion Check
    /// 🟢 يحدد ما إذا كان الهدف قد اكتمل (سنفترض 7 أيام)
    var isGoalComplete: Bool {
        return learnedStreak >= 7
    }

    // MARK: - Navigation
    enum Destination { case calendar, edit }
    
    func navigateTo(_ destination: Destination) {
        switch destination {
        case .calendar: showCalendarPage = true
        case .edit: showEditPage = true
        }
    }

    // MARK: - الأسبوع والتواريخ
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
    var canLogLearnedToday: Bool {
        let calendar = Calendar.current
        guard calendar.isDateInToday(selectedDate) else { return false }
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
    
    // MARK: - تسجيل اليوم ومنع التكرار
    func logLearned(for date: Date) {
        guard canLogLearnedToday else { return }
        
        learnedStreak = 7 // 💡 تعيين مباشر لـ 7 لأغراض الاختبار/الإنجاز الفوري
        points += 7
        dayStatuses[date] = .learned

        // ✅ افتح صفحة الإكمال فوراً
        if learnedStreak >= 7 {
            showCompletePage = true
        }
    }

    func logFreezed(for date: Date) {
        let calendar = Calendar.current
        guard calendar.isDateInToday(selectedDate) else { return }
        
        guard freezeCount < maxFreezes else { return }
        freezeCount += 1
        dayStatuses[date] = .freezed
    }

    func canFreeze() -> Bool {
        let calendar = Calendar.current
        guard calendar.isDateInToday(selectedDate) else { return false }
        
        return freezeCount < maxFreezes && (dayStatuses[selectedDate] == nil || dayStatuses[selectedDate] == .none)
    }
}

// ----------------------------------------------------
// ⚠️ ViewModels المدمجة (تحتاج إلى إزالتها إذا كانت موجودة كملفات منفصلة)
// ----------------------------------------------------

// [تم إزالة محتوى CalendarViewModel و LearningViewModel المرفق لتوحيد ActivityViewModel]

// HOME PAGE
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

class EditGoalViewModel: ObservableObject {
    // الخصائص المنشورة (Published) التي تراقبها الواجهة
    @Published var goalText: String = ""
    @Published var selectedDuration: Duration = .month // الحالة الافتراضية "Month" كما في الكود الأصلي

    // منطق الأعمال (Business Logic)
    
    // الإجراء الذي يتم استدعاؤه عند الضغط على زر المدة
    func selectDuration(_ duration: Duration) {
        selectedDuration = duration
        print("\(duration.rawValue) selected!")
    }
    
    // دالة لحفظ الهدف (يمكن تطويرها لاحقًا لإرسال البيانات)
    func saveGoal() {
        print("Saving Goal: \(goalText) with duration \(selectedDuration.rawValue)")
        // هنا يمكن إضافة منطق الحفظ إلى قاعدة البيانات أو تمرير البيانات
    }
    
    // خصائص مساعدة للعرض (View Helpers)
    
    // دالة لتحديد ما إذا كانت مدة معينة هي المدة المختارة حاليًا
    func isDurationSelected(_ duration: Duration) -> Bool {
        return selectedDuration == duration
    }
}

