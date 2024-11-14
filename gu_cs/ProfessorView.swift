import SwiftUI

struct ProfessorView: View {
    var professorName: String
    var about: String
    var image: Image?

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            if let image = image {
                image
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
                    .cornerRadius(10)
            }
            Text(professorName)
                .font(.largeTitle)
                .fontWeight(.bold)
            Text(about)
                .font(.body)
                .foregroundColor(.secondary)
            Spacer()
        }
        .padding()
        .navigationTitle(professorName)
    }
}

#Preview {
    ProfessorView(
        professorName: "Dr. John Doe", about: "An experienced professor in Computer Science.",
        image: Image(systemName: "person.circle"))
}
