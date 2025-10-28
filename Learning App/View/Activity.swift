import SwiftUI

// 💡 ملاحظة: يجب أن يكون ActivityViewModel يحتوي الآن على الدالة canLogLearnedToday (كما تم تحديثها سابقاً).

struct ActivityView: View {
    // ⭐️ يجب حقن الـ ViewModel في البيئة لتمكين CalendarView من استخدامه لاحقاً
    @StateObject private var viewModel = ActivityViewModel()
    // ❌ تم حذف @State private var isPressed لأنها لم تعد مستخدمة

    var body: some View {
        NavigationStack {
            VStack {
                header
                weekHeader
                Spacer()
                bottomButtons
            }
            .padding()
            // 💡 تمرير الـ ViewModel إلى البيئة هنا لكي تستخدمه CalendarView و EditPage
            .environmentObject(viewModel)
            
            .navigationDestination(isPresented: $viewModel.showCalendarPage) {
                // CalendarView   الوصول ل
                CalendarView()
            }
            .navigationDestination(isPresented: $viewModel.showEditPage) {
                EditPage() // يجب تعريف EditPage()
            }
            // ✅ الانتقال إلى صفحة الإكمال عندما يصبح التسلسل 7
            .navigationDestination(isPresented: $viewModel.showCompletePage) {
                complete()
            }
            .navigationBarTitleDisplayMode(.inline)
        }
        
    }

    // MARK: - Header
    private var header: some View {
        HStack(spacing: 10) {
            Text ("Activity")
                .font(.largeTitle.bold())
                
            // ... (بقية منطق Header) ...
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
            // ... (منطق عرض الشهر وأزرار التنقل) ...

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
//                            .overlay(
//                                Circle()
//                                    .stroke(isSelected ? Color("duration") : Color.white.opacity(0.1), lineWidth: 0.8)
//                            )
                            .foregroundStyle(isSelected ? .white : .gray)
                            .onTapGesture { viewModel.selectDay(day.date) }
                    }
                }
            }

            Divider().background(Color.white.opacity(0.5))

            Text("Learning Activity")
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.system(size: 16, weight: .semibold))

            activityCapsules
        }
        .padding()
        .glassEffect(in: .rect(cornerRadius: 16.0))
//        .glassEffect(.clear)
//        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
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

            // ⭐️ زر Learned Today: أصبح معطلاً بعد تسجيله لليوم الحالي (00:00 Reset)
            Button {
                viewModel.logLearned(for: viewModel.selectedDate)
            } label: {
                Text("Learned Today")
                    .font(.system(size: 45)).bold()
                    .frame(width: 274, height: 274)
                    .foregroundColor(.white)
                    .background(Color("duration"))
                    .clipShape(Circle())
                    .overlay(
                        // ... (تأثير الإطار) ...
                        Circle().stroke(Color.white.opacity(0.2), lineWidth: 1) // تبسيط الإطار
                    )
            }
            // ⭐️⭐️ شرط التعطيل الجديد ⭐️⭐️
            .disabled(!viewModel.canLogLearnedToday)
            .opacity(viewModel.canLogLearnedToday ? 1.0 : 0.4) // إظهار حالة التعطيل

            Spacer()

            Button {
                viewModel.logFreezed(for: viewModel.selectedDate)
            } label: {
                Text("Freezed Today")
                    .font(.headline)
                    .frame(width: 274, height: 48)
                    .foregroundColor(.white)
                    // 💡 تصحيح استخدام اللون: Color("Tef") بدلاً من Color.tef
                    .background(viewModel.canFreeze() ? Color("log") : Color("Tef"))
                    .clipShape(Capsule())
                    .overlay(
                        // ... (تأثير الإطار) ...
                        Capsule().stroke(Color.white.opacity(0.2), lineWidth: 1) // تبسيط الإطار
                    )
            }
            .disabled(!viewModel.canFreeze())

            Text("\(viewModel.freezeCount) / \(viewModel.maxFreezes) Freezes used")
                .font(.caption)
                .foregroundColor(.gray)
        }
        .padding(.bottom, 40)
    }
}

// ----------------------------------------------------
// 5. المعاينة (Preview)
// ----------------------------------------------------

#Preview("Dark Mode") {
    // 💡 توفير ActivityViewModel للبيئة ليعمل preview
    ActivityView()
       .preferredColorScheme(.dark)
        .environmentObject(ActivityViewModel())
}
