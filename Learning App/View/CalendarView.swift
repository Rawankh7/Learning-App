//
//  CalendarView.swift
//  Learning App
//
//  Created by rawan alkhaldi  on 04/05/1447 AH.
//
import SwiftUI
import UIKit

struct CalendarView: View {
    @StateObject private var viewModel = CalendarViewModel()
    @Environment(\.colorScheme) var scheme
    
    var body: some View {
        ZStack(alignment: .top){
            Text("All activities")
                .font(.system(size: 17, weight: .semibold))
                .foregroundColor(.white)
                .zIndex(3)
                .padding(.all)
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(spacing: 32) {
                        ForEach(Array(viewModel.months.enumerated()), id: \.offset) { index, month in
                            VStack(alignment: .leading, spacing: 16) {
                                Text(viewModel.monthYearString(for: month))
                                    .font(.system(size: 24, weight: .semibold))
                                    .foregroundColor(.white)
                                    .padding(.leading)
                                
                                // Weekday headers
                                HStack {
                                    ForEach(viewModel.dayOfWeekHeaders(), id: \.self) { day in
                                        Text(day)
                                            .font(.system(size: 14, weight: .medium))
                                            .frame(maxWidth: .infinity)
                                            .foregroundColor(.gray)
                                    }
                                }
                                
                                // Days grid
                                let days = viewModel.daysInMonth(for: month)
                                let columns = Array(repeating: GridItem(.flexible()), count: 7)
                                
                                LazyVGrid(columns: columns, spacing: 12) {
                                    ForEach(days, id: \.self) { day in
                                        if viewModel.isToday(day) {
                                            ZStack {
                                                Circle()
                                                    .fill(Color.orange)
                                                    .frame(width: 38, height: 38)
                                                Text(viewModel.dayString(for: day))
                                                    .font(.system(size: 24, weight: .bold))
                                                    .foregroundColor(.white)
                                            }
                                        } else {
                                            Text(viewModel.dayString(for: day))
                                                .font(.system(size: 20))
                                                .frame(width: 38, height: 38)
                                                .foregroundColor(.white)
                                        }
                                    }
                                }
                                
                                Divider()
                                    .background(Color.gray.opacity(0.4))
                                    .padding(.top, 10)
                            }
                            .id(index)
                        }
                    }
                    .padding(.horizontal)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            withAnimation(.easeInOut) {
                                proxy.scrollTo(viewModel.currentMonthIndex, anchor: .top)
                            }
                        }
                    }
                }
            }
         //   .background(Color("Background").ignoresSafeArea())
            LinearGradient(
                    gradient: Gradient(colors: [Color.black, Color.black.opacity(0)]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(height: 190)
                .ignoresSafeArea(edges: .top)
                .zIndex(2)
        }
    }
}
#Preview {
    CalendarView()

}
