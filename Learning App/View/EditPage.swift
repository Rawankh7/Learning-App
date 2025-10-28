// EditPage.swift
import SwiftUI

struct EditPage: View {
    // 1. استخدام @StateObject لإنشاء ViewModel
    @StateObject private var viewModel = EditGoalViewModel()
    @FocusState private var isGoalTextFocused: Bool

    var body: some View {
        // يجب أن تكون الواجهة مغلفة بـ NavigationStack ليعمل التنقل
        NavigationStack {
            ZStack {
                // الخلفية
                LinearGradient(
                    gradient: Gradient(colors: [Color.black, Color(red: 0.1, green: 0.1, blue: 0.1)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 30) {
                        
                        headerView
                        
                        // TextField
                        VStack(alignment: .leading, spacing: 15) {
                            Text("I want to learn")
                                .font(.system(size: 23))
                                .foregroundColor(.white)
                            
                            // ربط TextField بالـ ViewModel
                            TextField("Type Here...", text: $viewModel.goalText)
                                .font(.system(size: 18))
                                .foregroundColor(.gray)
                                .padding()
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(10)
                                .focused($isGoalTextFocused)
                            
                            Text("I want to learn in a")
                                .font(.system(size: 22))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        
                        // أزرار Week / Month / Year
                        durationButtons
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 10)
                }
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        isGoalTextFocused = true
                    }
                }
            }
            // إخفاء شريط التنقل الافتراضي والاعتماد على الشريط المخصص
            .toolbar(.hidden, for: .navigationBar)
        }
    }
    
    // شريط التنقل المخصص
    var headerView: some View {
        HStack {
            // 1. زر العودة (السهم) - يذهب إلى ActivityView
            NavigationLink(destination: ActivityView()) {
                Image(systemName: "chevron.left")
                    .frame(width: 44, height: 44)
                    .glassEffect(.clear)
                    .foregroundColor(.white)
                
                            .clipShape(Circle())
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
                                }
            .clipShape(Circle())
            
            Spacer()
            
            Text("Learning Goal")
                .font(.system(size: 28))
                .foregroundColor(.white)
            
            Spacer()
            
            // 2. زر الحفظ (الصح) - يذهب إلى ActivityView
            NavigationLink(destination: ActivityView().onAppear {
                viewModel.saveGoal() // استدعاء دالة الحفظ عند الانتقال
            }) {
                Image(systemName: "checkmark")
                    .font(.system(size: 23))
                    .frame(width: 44, height: 44)
                    .glassEffect(.clear)
                    .foregroundColor(.white)
                    .background(Color("duration"))
                    .overlay(
                        Circle()
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

            }
            .clipShape(Circle())
        }
        .padding(.horizontal, 16)
    }
    
    // أزرار المدة
    var durationButtons: some View {
        HStack(spacing: 20) {
            ButtonFactory(viewModel: viewModel, duration: .week)
            ButtonFactory(viewModel: viewModel, duration: .month)
            ButtonFactory(viewModel: viewModel, duration: .year)
        }
    }
}

// مكون فرعي معزول لزر المدة (يستخدم ViewModel لتحديد اللون)
struct ButtonFactory: View {
    @ObservedObject var viewModel: EditGoalViewModel
    let duration: Duration
    
    var body: some View {
        Button(action: {
            // استدعاء المنطق من ViewModel عند الضغط
            viewModel.selectDuration(duration)
        }) {
            Text(duration.rawValue)
                .font(.headline)
                .frame(width: 100, height: 48)
                .glassEffect(.clear)
                .foregroundColor(.white)
                .background(
                    // منطق التلوين: إذا كانت المدة مختارة، استخدم Color.duration، وإلا استخدم اللون الأسود
                    viewModel.isDurationSelected(duration) ? Color.duration.opacity(1) : Color.black.opacity(0.9)
                )
                .clipShape(Capsule())
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    EditPage()
}
