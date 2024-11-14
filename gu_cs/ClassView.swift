import SwiftUI

// View for displaying detailed information about a class
struct ClassView: View {
    var className: String // Name of the class
    var about: String // Description of the class
    var professorName: String // Name of the professor for the class

    var body: some View {
        ScrollView {
            ZStack {
                // Set background color for the entire view
                Color("PrimaryDarkPurple").ignoresSafeArea()
                
                VStack(alignment: .leading, spacing: 20) {
                    ZStack(alignment: .leading) {
                        // Background rectangle with shadow for the main content area
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.white)
                            .shadow(color: Color("PrimaryDarkPurple").opacity(0.15), radius: 4, x: 0, y: 2)
                        
                        VStack(alignment: .leading, spacing: 12) {
                            // Display class name as the title
                            Text(className)
                                .font(.title)
                                .fontWeight(.semibold)
                                .foregroundColor(Color("PrimaryDarkPurple"))
                                .padding(.top, 16)

                            // Display professor's name with a label
                            Text("Professor: \(professorName)")
                                .font(.title3)
                                .foregroundColor(Color("PrimaryDarkPurple"))
                                .padding(.bottom, 8)
                            
                            // Divider line with a custom color
                            Divider()
                                .background(Color("PrimaryDarkPurple"))
                            
                            // Section title for class description
                            Text("About the Course")
                                .font(.headline)
                                .foregroundColor(Color("PrimaryDarkPurple"))

                            // Display the description text of the class
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
                .toolbar {
                    // Custom navigation title with color change for the toolbar
                    ToolbarItem(placement: .principal) {
                        Text(className)
                            .font(.headline)
                            .foregroundColor(Color("PrimaryDarkPurple"))
                    }
                }
                .navigationBarTitleDisplayMode(.inline) // Display title inline in navigation bar
            }
        }
    }
}

#Preview {
    ClassView(
        className: "Introduction to Computer Science",
        about: "This course provides an overview of computer science.",
        professorName: "Dr. Jane Smith"
    )
}
