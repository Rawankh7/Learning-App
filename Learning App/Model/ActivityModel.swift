//
//  ActivityModel.swift
//  Learning App
//
//  Created by rawan alkhaldi on 30/04/1447 AH.
//

import Foundation

/// 🧱 الـ Model: يمثل البيانات الأساسية لشاشة النشاط.
struct ActivityDay: Identifiable {
    let id = UUID()
    let date: Date
}

/// امتداد لتسهيل حساب بداية الأسبوع.
extension Calendar {
    func startOfWeek(for date: Date) -> Date {
        let comps = dateComponents([.yearForWeekOfYear, .weekOfYear], from: date)
        return self.date(from: comps) ?? date
    }
}
