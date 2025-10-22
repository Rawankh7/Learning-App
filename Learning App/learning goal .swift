import SwiftUI

struct LearningGoalView: View {
    @State private var goalText: String = "" // Binding صالح لـ TextField
    @FocusState private var isGoalTextFocused: Bool
    
    var body: some View {
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
                        
                        // العنوان والـ Navigation Buttons
                        HStack {
                            NavigationLink(destination: ContentView()) {
                                Image(systemName: "chevron.left")
                                    .frame(width: 44, height: 44)
                                    .glassEffect(.clear)
                                    .foregroundColor(.white)
                                    
                                    .background(
                                        Color.gray.opacity(0.1)
                                            .clipShape(Circle())
                                            .background(
                                                Color.black.opacity(0.9)
                                                
                                            )
                                    )
                                    .clipShape(Capsule())
//
                            }
                            
                            Spacer()
                            
                            Text("Learning Goal")
                                .font(.system(size: 28))
                                .foregroundColor(.white)
                            
                            Spacer()
                            
                            NavigationLink(destination: ContentView()) {
                                Image(systemName: "checkmark")
                                    .font(.system(size: 23))
                                    .frame(width: 44, height: 44)
                                    .glassEffect(.clear)
                                    .foregroundColor(.white)
                                    
                                    .background(
                                        Color.duration.opacity(1)
                                            .clipShape(Circle())
                                            .background(
                                                Color.black.opacity(0.9)
                                                 
                                            )
                                    )
                                    .clipShape(Circle())
//
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 10)
                        
                        // TextField
                        VStack(alignment: .leading, spacing: 15) {
                            Text("I want to learn")
                                .font(.system(size: 23))
                                .foregroundColor(.white)
                            
                            TextField("Type Here...", text: $goalText)
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
                        HStack(spacing: 20) {
                            Button(action: {
                                print("Week button tapped!")
                            }) {
                                Text("Week")
                                    .font(.headline)
                                    .foregroundColor(.white.opacity(0.9))
                                    .frame(width: 100, height: 48)
                                    .glassEffect(.clear)

                                    .background(
                                        Color.black.opacity(0.9)
                                    )
                                    .clipShape(Capsule())
//                                    .overlay(
//                                        Capsule().stroke(
//                                            LinearGradient(
//                                                colors: [
//                                                    Color.orange.opacity(0.45),
//                                                    Color.white.opacity(0.45),
//                                                    Color.white.opacity(0.45),
//                                                    Color.black.opacity(0.20),
//                                                    Color.black.opacity(0.20),
//                                                    Color.black.opacity(0.20),
//                                                    Color.black.opacity(0.20),
//                                                    Color.white.opacity(0.20),
//                                                ],
//                                                startPoint: .topLeading,
//                                                endPoint: .bottom
//                                            ),
//                                            lineWidth: 1
//                                        )
//                                    )
                            }
                            .buttonStyle(PlainButtonStyle())
                            
                            Button(action: { print("Month tapped") }) {
                                Text("Month")
                                    .frame(width: 100, height: 48)
                                    .glassEffect(.clear)

                                    .font(.headline)
                                    .foregroundColor(.white)
                                   
                                    .background(
                                        Color.duration.opacity(1)
                                           
                                    )
                                    .clipShape(Capsule())
//                                    .overlay(
//                                        Capsule().stroke(
//                                            LinearGradient(
//                                                colors: [
//                                                    Color.orange.opacity(0.45),
//                                                    Color.white.opacity(0.45),
//                                                    Color.white.opacity(0.45),
//                                                    Color.black.opacity(0.20),
//                                                    Color.black.opacity(0.20),
//                                                    Color.black.opacity(0.20),
//                                                    Color.black.opacity(0.20),
//                                                    Color.white.opacity(0.20),
//                                                ],
//                                                startPoint: .topLeading,
//                                                endPoint: .bottom
//                                            ),
//                                            lineWidth: 1
//                                        )
//                                    )
                            }
                            .buttonStyle(PlainButtonStyle())
                            
                            Button(action: { print("Year tapped") }) {
                                Text("Year")
                                    .font(.headline)
                                    .frame(width: 100, height: 48)
                                    .glassEffect(.clear)

                                    .foregroundColor(.white.opacity(0.9))
                                  
                                    .background(
                                        Color.black.opacity(0.9)
                                            
                                    )
                                    .clipShape(Capsule())
//                                    .overlay(
//                                        Capsule().stroke(
//                                            LinearGradient(
//                                                colors: [
//                                                    Color.orange.opacity(0.45),
//                                                    Color.white.opacity(0.45),
//                                                    Color.white.opacity(0.45),
//                                                    Color.black.opacity(0.20),
//                                                    Color.black.opacity(0.20),
//                                                    Color.black.opacity(0.20),
//                                                    Color.black.opacity(0.20),
//                                                    Color.white.opacity(0.20),
//                                                ],
//                                                startPoint: .topLeading,
//                                                endPoint: .bottom
//                                            ),
//                                            lineWidth: 1
//                                        )
//                                    )
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 30)
                }
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        isGoalTextFocused = true
                    }
                }
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    LearningGoalView()
}
