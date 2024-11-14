import SwiftUI

struct ClassView: View {
    var className: String
    var about: String
    var professorName: String

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(className)
                .font(.largeTitle)
                .fontWeight(.bold)
            Text("Professor: \(professorName)")
                .font(.title2)
                .foregroundColor(.secondary)
            Text(about)
                .font(.body)
                .foregroundColor(.secondary)
            Spacer()
        }
        .padding()
        .navigationTitle(className)
    }
}

#Preview {
    ClassView(
        className: "Introduction to Computer Science",
        about: "This course provides an overview of computer science.",
        professorName: "Dr. Jane Smith")
}
