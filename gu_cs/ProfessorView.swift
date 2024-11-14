import SwiftUI

// View for displaying detailed information about a professor
struct ProfessorView: View {
    var professorName: String // Name of the professor
    var about: String // Description or bio of the professor
    var image: Image? // Optional image of the professor

    var body: some View {
        ScrollView {
            ZStack {
                // Set background color for the entire view
                Color("PrimaryDarkPurple").ignoresSafeArea()

                // Main content container with vertical spacing
                VStack(alignment: .leading, spacing: 20) {
                    ZStack(alignment: .leading) {
                        // Background rectangle with shadow for the main content area
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.white)
                            .shadow(color: Color("PrimaryDarkPurple").opacity(0.15), radius: 4, x: 0, y: 2)
                        
                        // VStack to hold the content inside the rectangle
                        VStack(alignment: .leading, spacing: 12) {
                            // Center the image if available
                            if let image = image {
                                HStack {
                                    Spacer()
                                    image
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: 200)
                                        .cornerRadius(10)
                                        .padding(.top, 16)
                                    Spacer()
                                }
                            }
                            
                            // Display professor name in large, bold font
                            Text(professorName)
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundColor(Color("PrimaryDarkPurple"))
                            
                            // Divider line with custom color
                            Divider()
                                .background(Color("PrimaryDarkPurple"))
                            
                            // Section title for professor bio
                            Text("About the Professor")
                                .font(.headline)
                                .foregroundColor(Color("PrimaryDarkPurple"))

                            // Display professor's description or bio
                            Text(about)
                                .font(.body)
                                .foregroundColor(Color("PrimaryDarkPurple"))
                                .padding(.bottom, 16)
                        }
                        .padding(16) // Padding for the content within the rectangle
                    }
                    .padding(.horizontal, 4) // Outer padding for the content rectangle
                    
                    Spacer() // Pushes content to the top
                }
                .padding()
            }
            .toolbar {
                // Custom navigation title with color change for the toolbar
                ToolbarItem(placement: .principal) {
                    Text(professorName)
                        .font(.headline)
                        .foregroundColor(Color("PrimaryDarkPurple"))
                }
            }
            .navigationBarTitleDisplayMode(.inline) // Display title inline in navigation bar
        }
    }
}

#Preview {
    ProfessorView(
        professorName: "Dr. John Doe",
        about: "An experienced professor in Computer Science.",
        image: Image(systemName: "person.circle")
    )
}
