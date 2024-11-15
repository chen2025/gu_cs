import CoreData
import SwiftUI

/// A view to display a list of professors, allowing the user to favorite professors by long-pressing on each item.
/// Professors marked as favorites are indicated with a yellow icon and are stored in Core Data.
struct ProfessorsView: View {
    // Access the managed object context environment variable for Core Data
    @Environment(\.managedObjectContext) private var viewContext
    
    // Array of data objects representing professors and classes; only professors are displayed in this view
    var csList: [CS]

    // Fetch request to retrieve favorite items (stored in Core Data), sorted by professor name
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.professorName, ascending: true)],
        animation: .default)
    private var favoritedItems: FetchedResults<Item>

    var body: some View {
        // Navigation stack to handle navigation within the view
        NavigationStack {
            ZStack {
                // Set background color for the entire view
                Color("PrimaryDarkPurple").ignoresSafeArea()

                // List displaying each professor from csList, excluding classes
                List {
                    ForEach(csList.filter { !$0.isClass }) { cs in
                        ZStack(alignment: .trailing) {
                            // Background rectangle with shadow for each professor item
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.white)
                                .shadow(color: Color("PrimaryDarkPurple").opacity(0.15), radius: 4, x: 0, y: 2)
                                .frame(maxWidth: .infinity)
                            
                            HStack {
                                // Display an icon representing a professor with color indicating favorite status
                                Image(systemName: "person.fill")
                                    .foregroundColor(isAlreadyFavorited(cs: cs) ? .yellow : Color("PrimaryDarkPurple"))
                                    .font(.system(size: 24))
                                    .animation(.easeInOut(duration: 0.3), value: isAlreadyFavorited(cs: cs))

                                // Display the professor's name, or "Unknown Professor" if nil
                                Text(cs.professorName ?? "Unknown Professor")
                                    .font(.headline)
                                    .foregroundColor(Color("PrimaryDarkPurple"))

                                Spacer()

                                // Chevron icon indicating navigability to detailed professor view
                                Image(systemName: "chevron.right")
                                    .foregroundColor(Color("PrimaryDarkPurple"))
                                    .font(.system(size: 18))
                                    .padding(.trailing, 10)
                            }
                            .padding(.vertical, 12)
                            .padding(.horizontal, 16)
                            .frame(maxWidth: .infinity)
                            .background(
                                // Background rectangle with shadow for the HStack content
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.white)
                                    .shadow(color: Color("PrimaryDarkPurple").opacity(0.15), radius: 4, x: 0, y: 2)
                            )
                        }
                        .padding(.horizontal, 4)
                        .background(
                            // Navigation link to ProfessorView for detailed professor information
                            NavigationLink("", destination: ProfessorView(
                                professorName: cs.professorName ?? "Unknown Professor",
                                about: cs.about,
                                image: cs.image
                            ))
                            .opacity(0) // Hide the navigation link to maintain custom layout
                        )
                        .listRowBackground(Color.clear) // Set list row background to transparent
                        .padding(.vertical, 6)
                        .gesture(
                            // Long press gesture to add the professor to favorites if not already favorited
                            LongPressGesture(minimumDuration: 1)
                                .onEnded { _ in
                                    if !isAlreadyFavorited(cs: cs) {
                                        saveToFavorites(cs: cs)
                                    }
                                }
                        )
                    }
                }
                .scrollContentBackground(.hidden) // Hide the default list background color
                .background(Color("PrimaryDarkPurple")) // Set custom background color
            }
            .listStyle(InsetGroupedListStyle()) // Apply inset grouped list style for appearance
        }
    }

    /// Saves the given professor to Core Data as a favorite.
    /// - Parameter cs: The `CS` object representing the professor to be favorited.
    private func saveToFavorites(cs: CS) {
        // Create a new Item instance to represent the professor in Core Data
        let newItem = Item(context: viewContext)
        newItem.professorName = cs.professorName // Set the professor's name
        newItem.isClass = false // Mark this item as a professor (not a class)
        newItem.about = cs.about // Store additional details about the professor
        newItem.imageName = cs.imageName // Store the associated image name, if available

        // Attempt to save the new favorite item to Core Data, handling potential errors
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }

    /// Checks if a given professor is already favorited.
    /// - Parameter cs: The `CS` object representing the professor.
    /// - Returns: A Boolean indicating if the professor is already in the favorites list.
    private func isAlreadyFavorited(cs: CS) -> Bool {
        // Check if favorited items contain this professor's name and ensure it is marked as a professor (not a class)
        return favoritedItems.contains { !$0.isClass && $0.professorName == cs.professorName }
    }
}
