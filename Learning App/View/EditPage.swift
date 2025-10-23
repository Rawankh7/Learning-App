import SwiftUI

struct EditPage: View {
    var body: some View {
        VStack(spacing: 16) {
            Text("Edit")
                .font(.largeTitle.bold())
                .foregroundStyle(.white)
            Text("This is a placeholder for the edit page.")
                .foregroundStyle(.gray)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.ignoresSafeArea())
        .navigationTitle("Edit")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        EditPage()
            .preferredColorScheme(.dark)
    }
}
