import CoreData
import SwiftUI

// View for displaying a list of professors
struct ProfessorsView: View {
    @Environment(\.managedObjectContext) private var viewContext // Environment property for Core Data context
    var csList: [CS] // Array of data objects representing professors and classes

    var body: some View {
        // Main navigation stack for the view
        NavigationStack {
            ZStack {
                // Set background color for the entire view
                Color("PrimaryDarkPurple").ignoresSafeArea()

                // List displaying each professor from csList
                List {
                    // Filter the list to include only professors, excluding classes
                    ForEach(csList.filter { !$0.isClass }) { cs in
                        ZStack(alignment: .trailing) {
                            // Background rectangle with shadow for each list item
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.white)
                                .shadow(color: Color("PrimaryDarkPurple").opacity(0.15), radius: 4, x: 0, y: 2)
                                .frame(maxWidth: .infinity)
                            
                            // Horizontal stack for the content within each professor item
                            HStack {
                                // Person icon to represent a professor
                                Image(systemName: "person.fill")
                                    .foregroundColor(Color("PrimaryDarkPurple"))
                                    .font(.system(size: 24))

                                // Display professor name with headline font
                                Text(cs.professorName ?? "Unknown Professor")
                                    .font(.headline)
                                    .foregroundColor(Color("PrimaryDarkPurple"))

                                Spacer()

                                // Chevron icon to indicate navigation
                                Image(systemName: "chevron.right")
                                    .foregroundColor(Color("PrimaryDarkPurple"))
                                    .font(.system(size: 18))
                                    .padding(.trailing, 10)
                            }
                            .padding(.vertical, 12)
                            .padding(.horizontal, 16)
                            .frame(maxWidth: .infinity)
                            .background(
                                // Background rectangle with shadow for content
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.white)
                                    .shadow(color: Color("PrimaryDarkPurple").opacity(0.15), radius: 4, x: 0, y: 2)
                            )
                        }
                        .padding(.horizontal, 4)
                        .background(
                            // Navigation link to ProfessorView for detailed view of professor
                            NavigationLink("", destination: ProfessorView(
                                professorName: cs.professorName ?? "Unknown Professor",
                                about: cs.about,
                                image: cs.image
                            ))
                            .opacity(0) // Make the navigation link transparent to keep custom layout
                        )
                        .listRowBackground(Color.clear) // Set row background to transparent
                        .padding(.vertical, 6)
                    }
                }
                .scrollContentBackground(.hidden) // Hide the default list background
                .background(Color("PrimaryDarkPurple")) // Set custom background color for the list
            }
            .listStyle(InsetGroupedListStyle()) // Apply list style for grouped appearance
        }
    }
}

#Preview {
    ProfessorsView(csList: ApplicationData().userData)
}
