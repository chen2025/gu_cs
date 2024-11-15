import CoreData
import SwiftUI

/// A view to display a list of classes, allowing the user to favorite classes by long-pressing on each item.
/// Classes marked as favorites are indicated with a yellow icon and are stored in Core Data.
struct ClassesView: View {
    // Access the managed object context environment variable for Core Data
    @Environment(\.managedObjectContext) private var viewContext
    
    // Array of data objects representing professors and classes; only classes are displayed in this view
    var csList: [CS]

    // Fetch request to retrieve favorite items (stored in Core Data), sorted by class name
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.csClassName, ascending: true)],
        animation: .default)
    private var favoritedItems: FetchedResults<Item>
    
    // State variable to track the most recently saved item's ID (optional)
    @State private var savedItemID: UUID?

    var body: some View {
        // Navigation stack to handle navigation within the view
        NavigationStack {
            ZStack {
                // Set background color for the entire view
                Color("PrimaryDarkPurple").ignoresSafeArea()

                // List displaying each class from csList, excluding professors
                List {
                    ForEach(csList.filter { $0.isClass }) { cs in
                        ZStack(alignment: .trailing) {
                            // Background rectangle with shadow for each class item
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.white)
                                .shadow(color: Color("PrimaryDarkPurple").opacity(0.15), radius: 4, x: 0, y: 2)
                                .frame(maxWidth: .infinity)
                            
                            HStack {
                                // Display an icon representing a class with color indicating favorite status
                                Image(systemName: "book.fill")
                                    .foregroundColor(isAlreadyFavorited(cs: cs) ? .yellow : Color("PrimaryDarkPurple"))
                                    .font(.system(size: 24))
                                    .animation(.easeInOut(duration: 0.3), value: isAlreadyFavorited(cs: cs))

                                // Display the class name, or "Unknown Class" if nil
                                Text(cs.csClassName ?? "Unknown Class")
                                    .font(.headline)
                                    .foregroundColor(Color("PrimaryDarkPurple"))

                                Spacer()

                                // Chevron icon indicating navigability to detailed class view
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
                            // Navigation link to ClassView for detailed class information
                            NavigationLink("", destination: ClassView(
                                className: cs.csClassName ?? "Unknown Class",
                                about: cs.about,
                                professorName: cs.professorName ?? "Unknown Professor"
                            ))
                            .opacity(0) // Hide the navigation link to maintain custom layout
                        )
                        .listRowBackground(Color.clear) // Set list row background to transparent
                        .padding(.vertical, 6)
                        .gesture(
                            // Long press gesture to add the class to favorites if not already favorited
                            LongPressGesture(minimumDuration: 1)
                                .onEnded { _ in
                                    if !isAlreadyFavorited(cs: cs) {
                                        saveToFavorites(cs: cs)
                                        savedItemID = cs.id
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

    /// Saves the given class to Core Data as a favorite.
    /// - Parameter cs: The `CS` object representing the class to be favorited.
    private func saveToFavorites(cs: CS) {
        // Create a new Item instance to represent the class in Core Data
        let newItem = Item(context: viewContext)
        newItem.csClassName = cs.csClassName // Set the class name
        newItem.isClass = true // Mark this item as a class (not a professor)
        newItem.professorName = cs.professorName // Associate the professor's name if available
        newItem.about = cs.about // Store additional details about the class
        newItem.imageName = cs.imageName // Store the associated image name, if available

        // Attempt to save the new favorite item to Core Data, handling potential errors
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }

    /// Checks if a given class is already favorited.
    /// - Parameter cs: The `CS` object representing the class.
    /// - Returns: A Boolean indicating if the class is already in the favorites list.
    private func isAlreadyFavorited(cs: CS) -> Bool {
        // Check if favorited items contain this class name and ensure it is marked as a class (not a professor)
        return favoritedItems.contains { $0.isClass && $0.csClassName == cs.csClassName }
    }
}
