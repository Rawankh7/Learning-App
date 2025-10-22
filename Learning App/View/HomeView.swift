import SwiftUI

struct ContentView: View {
    @State private var viewModel = LearningViewModel()
    @FocusState private var isGoalTextFocused: Bool

    var body: some View {
        NavigationStack {
            

                VStack(spacing: 20) {
                    Spacer().frame(height: 10)

                    // 🔥 أيقونة الفليم
                    Button(action: {}) {
                        Image(systemName: "flame.fill")
                            .font(.largeTitle)
                            .foregroundColor(.orange)
                            .frame(width: 109, height: 109)
                            .background(.button)
                            .clipShape(Circle())
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

                    // 👋 الترحيب
                    VStack(alignment: .leading, spacing: 0) {
                        Text("Hello Learner")
                            .font(.system(size: 34, weight: .bold))
                            .foregroundColor(.white)
                        Text("This app will help you learn everyday!")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }

                    // 🎯 الهدف
                    Text("I want to learn")
                        .font(.system(size: 22))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    TextField("Type Here...", text: $viewModel.goal.text)
                        .font(.system(size: 18))
                        .foregroundColor(.gray)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(10)
                        .focused($isGoalTextFocused)

                    Divider().background(Color.white.opacity(0.3))

                    // 📅 اختيار المدة
                    Text("I want to learn in a")
                        .font(.system(size: 22))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    // أزرار Week / Month / Year
                    HStack(spacing: 20) {
                        ForEach(Period.allCases) { period in
                            Button {
                                viewModel.selectPeriod(period)
                            } label: {
                                Text(period.rawValue)
                                    .font(.headline)
                                    .frame(width: 100, height: 48)
                                    .foregroundColor(
                                        viewModel.goal.selectedPeriod == period
                                        ? .white : .white.opacity(0.7)
                                    )
                                    .background(
                                        viewModel.goal.selectedPeriod == period
                                        ? Color("duration")
                                        : Color.black.opacity(0.7)
                                    )
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
                            }
                            .glassEffect(.clear)
                            .buttonStyle(.plain)
                        }
                    }

                    Spacer()

                    // 🚀 زر البداية
                    NavigationLink(destination: ActivityTopView()) {
                        Text("Start Learning")
                            .font(.headline)
                            .frame(width: 200, height: 50)
                            .foregroundColor(.white)
                            .background(Color("duration"))
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

                    Spacer().frame(height: 20)
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 50)
                    }
    }
}

#Preview {
    ContentView()
        .preferredColorScheme(.dark)
}
