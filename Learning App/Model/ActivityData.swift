// Calendar.swift (الملف الأساسي للـ Model)

import Foundation
import SwiftUI // ضروري لـ DayStatus.color

/// 🧱 الـ Model: يمثل البيانات الأساسية ليوم نشاط.
struct ActivityDay: Identifiable {
    let id = UUID()
    let date: Date
}

/// 🧱 الـ Model: حالة كل يوم
enum DayStatus {
    case none, learned, freezed

    var color: Color {
        switch self {
        case .none: return Color(.secondarySystemBackground)
        case .learned: return Color("duration")
        case .freezed: return Color("Tef")
        }
    }

    var overlayColor: Color {
        switch self {
        case .none: return Color.clear
        case .learned: return Color("duration").opacity(0.6)
        case .freezed: return Color("Tef").opacity(0.6)
        }
    }
}

/// امتداد لتسهيل حساب بداية الأسبوع.
extension Calendar {
    func startOfWeek(for date: Date) -> Date {
        let comps = dateComponents([.yearForWeekOfYear, .weekOfYear], from: date)
        return self.date(from: comps) ?? date
    }
}

enum Duration: String, CaseIterable {
    case week = "Week"
    case month = "Month"
    case year = "Year"
}

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

