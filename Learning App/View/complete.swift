//
//  complete.swift
//  Learning App
//
//  Created by rawan alkhaldi  on 03/05/1447 AH.
//

import SwiftUI

struct complete: View {
    @StateObject private var viewModel = ActivityViewModel()

var body: some View {
        NavigationStack {
            VStack {
                header
                weekHeader
                Spacer()
                bottomButtons
              }
            .padding()
            .navigationDestination(isPresented: $viewModel.showCalendarPage) {
                CalendarView()
            }
            .navigationDestination(isPresented: $viewModel.showEditPage) {
                EditPage()
            }
            // ✅ NEW: navigate to LearningGoalView
            .navigationDestination(isPresented: $viewModel.showcomplete) {
                EditPage()
            }
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    // MARK: - Header
    private var header: some View {
        HStack(spacing: 10) {
            Text("Activity")
                .font(.system(size: 34, weight: .bold))
                .foregroundStyle(.white)

            Spacer()

            Button { viewModel.navigateTo(.calendar) } label: {
                Image(systemName: "calendar")
                    .frame(width: 44, height: 44)
    .glassEffect(.clear)
                    .foregroundStyle(.white.opacity(0.8))
                    .font(.system(size: 25, weight: .semibold))
            }

            Button { viewModel.navigateTo(.edit) } label: {
                Image(systemName: "pencil.and.outline")
                    .frame(width: 44, height: 44)
                    .glassEffect(.clear)
                    .foregroundStyle(.white.opacity(0.8))
                    .font(.system(size: 25, weight: .semibold))
            }
        }
    }

    // MARK: - Week Header
    private var weekHeader: some View {
        VStack(spacing: 12) {
            HStack {
                Text(viewModel.currentWeekStart, format: .dateTime.month(.wide).year())
                    .font(.title2.bold())
                    .foregroundStyle(.white)

                Spacer()

                HStack(spacing: 12) {
                    Button { viewModel.moveWeek(by: -1) } label: {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundStyle(Color("duration"))
                    }

                    Button { viewModel.moveWeek(by: 1) } label: {
                        Image(systemName: "chevron.right")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundStyle(Color("duration"))
                    }
                }
            }

            // الأيام
            HStack(spacing: 12) {
                ForEach(viewModel.currentWeekDays) { day in
                    let isSelected = viewModel.isSelected(day.date)
                    let bgColor = viewModel.dayColor(for: day.date)
                    let overlay = viewModel.dayOverlay(for: day.date)

                    VStack(spacing: 6) {
                        Text(day.date, format: .dateTime.weekday(.narrow))
                            .font(.caption)
                            .foregroundStyle(.gray)

                        Text(day.date, format: .dateTime.day())
                            .font(.headline.weight(.semibold))
                            .frame(width: 42, height: 42)
                            .background(
                                Circle()
                                    .fill(bgColor)
                                    .shadow(color: isSelected ? overlay : .clear, radius: 6, y: 2)
                            )
                            .overlay(
                                Circle()
                                    .stroke(isSelected ? Color("duration") : Color.white.opacity(0.1), lineWidth: 0.8)
                            )
                            .foregroundStyle(isSelected ? .white : .gray)
                            .onTapGesture { viewModel.selectDay(day.date) }
                    }
                }
            }

            Divider().background(Color.gray.opacity(0.5))

            Text("Learning Swift")
            // Changed "Learning Activity" to "Learning Swift" to match the image
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.system(size: 16, weight: .semibold))

            activityCapsules
        }
        .padding()
      //  .background(.ultraThinMaterial)
          .glassEffect(in: RoundedRectangle(cornerRadius: 16.0))
    }

    // MARK: - كبسولات الأنشطة
    private var activityCapsules: some View {
        HStack(spacing: 15) {
            capsuleView(image: "flame.fill", color: .orange, count: viewModel.learnedStreak,
                        titleSingular: "Day Learned", titlePlural: "Days Learned", backgroundColor: Color("Act"))

            capsuleView(image: "cube.fill", color: .cyan, count: viewModel.freezeCount,
                        titleSingular: "Day Freezed", titlePlural: "Days Freezed", backgroundColor: Color("Tef"))
        }
    }

    private func capsuleView(image: String, color: Color, count: Int, titleSingular: String, titlePlural: String, backgroundColor: Color) -> some View {
        HStack(spacing: 8) {
            Image(systemName: image)
                .foregroundColor(color)
            VStack(alignment: .leading, spacing: 2) {
                Text("\(count)").font(.headline.bold())
                Text(count == 1 ? titleSingular : titlePlural).font(.caption)
            }
            .foregroundColor(.white)
        }
        .frame(width: 160, height: 69)
        .background(backgroundColor)
        .clipShape(Capsule())
    }

    // MARK: - أزرار أسفل الشاشة
    private var bottomButtons: some View {
        VStack {
            Spacer()

            // ----------------- الجزء الجديد من الصورة -----------------
            VStack(spacing: 20) {
                Image(systemName: "hands.and.sparkles.fill")
                    .font(.system(size: 40))
                    .foregroundColor(.orange)
                
                   

                Text("Will done!")
                    .font(.title2.bold())
                    .foregroundColor(.white)

                Text("Goal completed! start learning again or\nset new learning goal")
                    .font(.subheadline)
                    .foregroundStyle(.gray.opacity(0.8))
                    .multilineTextAlignment(.center)
                

               
            }
            Spacer()
            // ----------------- نهاية الجزء الجديد -----------------
            
          
            Button {
                // ✅ Navigate to LearningGoalView
                viewModel.showcomplete = true
            } label: {
                Text("Set new learning goal") // هذا هو الزر الثاني القديم، تم تعديل نصه لكي لا يظهر مرتين بنفس النص
                    .font(.headline)
                    .frame(width: 274, height: 48)
                    .foregroundColor(.white)
                    .background(viewModel.canFreeze() ? Color("duration") : Color.tef)
                    .clipShape(Capsule())
                    .overlay(
                        Capsule()
                            .stroke(
                                LinearGradient(
                                    colors: [
                                        Color.orange.opacity(0.45),
                                        Color.white.opacity(0.45),
                                        Color.white.opacity(0.45),
                                        Color.black.opacity(0.20),
                                        Color.black.opacity(0.20),
                                        Color.black.opacity(0.20),
                                        Color.black.opacity(0.20),
                                        Color.white.opacity(0.20),
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottom
                                ),
                                lineWidth: 1
                            )
                    )
                    .padding()
            }
            

           Text("Set same learning goal and duration")
                .foregroundColor(.duration)
        }
        //.padding(.bottom, 40)
    }
}

#Preview("Dark Mode") {
    complete()
      .preferredColorScheme(.dark)
}

