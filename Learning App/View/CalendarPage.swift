import SwiftUI

struct CalendarPage: View {
    var body: some View {
        VStack(spacing: 16) {
            Text("Calendar")
                .font(.largeTitle.bold())
                .foregroundStyle(.white)
            Text("This is a placeholder for the calendar page.")
                .foregroundStyle(.gray)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.ignoresSafeArea())
        .navigationTitle("Calendar")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        CalendarPage()
            .preferredColorScheme(.dark)
    }
}
