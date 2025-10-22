import SwiftUI

/// 🎨 الـ View: الواجهة التي تتفاعل مع المستخدم وتعرض بيانات الـ ViewModel.
struct ActivityTopView: View {
    @Environment(\.colorScheme) private var colorScheme
    @State private var viewModel = ActivityViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                // MARK: - شريط العنوان
                HStack(spacing: 10) {
                    Text("Activity")
                        .font(.system(size: 34, weight: .bold))
                        .foregroundStyle(.white)
                    
                    Spacer()
                    
                    Image(systemName: "calendar")
                        .frame(width: 44, height: 44)
                        .glassEffect(.clear)
                        .foregroundStyle(Color.white.opacity(0.8))
                        .font(.system(size: 25, weight: .semibold))
                    
                    Image(systemName: "pencil.and.outline")
                        .frame(width: 44, height: 44)
                        .glassEffect(.clear)
                        .foregroundStyle(Color.white.opacity(0.8))
                        .font(.system(size: 25, weight: .semibold))
                }
                .padding(.horizontal)
                
                // MARK: - رأس الأسبوع
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
                    
                    // MARK: - الأيام
                    HStack(spacing: 12) {
                        ForEach(viewModel.currentWeekDays) { day in
                            let isSelected = viewModel.isSelected(day.date)
                            
                            VStack(spacing: 6) {
                                Text(day.date, format: .dateTime.weekday(.narrow))
                                    .font(.caption)
                                    .foregroundStyle(.gray)
                                
                                Text(day.date, format: .dateTime.day())
                                    .font(.headline.weight(.semibold))
                                    .frame(width: 42, height: 42)
                                    .background(
                                        Circle()
                                            .fill(isSelected ? Color("duration") : Color(.secondarySystemBackground))
                                            .shadow(color: isSelected ? .orange.opacity(0.5) : .clear, radius: 6, y: 2)
                                    )
                                    .overlay(
                                        Circle()
                                            .stroke(
                                                isSelected ? Color("duration") :
                                                Color.white.opacity(0.1),
                                                lineWidth: 0.8
                                            )
                                    )
                                    .foregroundStyle(isSelected ? .white : .gray)
                                    .onTapGesture { viewModel.selectDay(day.date) }
                            }
                        }
                    }
                    
                    Divider()
                        .background(Color.white.opacity(0.5))
                    
                    Text("Learning Activity")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.system(size: 16, weight: .semibold))
                    
                    // MARK: - كبسولات الأنشطة
                    HStack {
                        Text("")
                            .frame(width: 160, height: 69)
                            .background(Color("Act"))
                            .clipShape(Capsule())
                        
                        Spacer().frame(width: 15)
                        
                        Text("")
                            .frame(width: 160, height: 69)
                            .background(Color("Tef"))
                            .clipShape(Capsule())
                    }
                }
                .padding()
                .glassEffect(in: .rect(cornerRadius: 16.0))
                
                Spacer()
                
                // MARK: - الأزرار السفلية
                VStack {
                    Spacer()
                    
                    Text("Log as Learned")
                        .font(.system(size: 45))
                        .bold()
                        .frame(width: 274, height: 274)
                        .glassEffect(.clear)
                        .background(Color("orange"))
                        .clipShape(Circle())
                    
                    Spacer()
                    
                    NavigationLink(destination: ActivityTopView()) {
                        Text("Log as Freezed")
                            .font(.headline)
                            .frame(width: 274, height: 48)
                            .foregroundColor(.white)
                            .background(Color("log"))
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
                            .glassEffect(.clear)
                    }
                    
                    Text("1 out of 2 Freezes used")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                .padding(.bottom, 40)
            }
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview("Dark Mode") {
    ActivityTopView()
        .preferredColorScheme(.dark)
}
