import CoreData
import SwiftUI

/// A view to display a list of favorited items (both classes and professors),
/// allowing the user to view, navigate to details, or delete favorites from the list.
/// Items are stored in Core Data and displayed with a yellow icon to indicate favorited status.
struct FavoritesView: View {
    // Access the managed object context environment variable for Core Data
    @Environment(\.managedObjectContext) private var viewContext
    
    // Fetch request to retrieve favorite items (stored in Core Data), sorted by class name
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.csClassName, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>
    
    // State variable to track the edit mode for handling deletion
    @State private var editMode: EditMode = .inactive

    var body: some View {
        // Navigation stack to handle navigation within the view
        NavigationStack {
            ZStack {
                // Set background color for the entire view
                Color("PrimaryDarkPurple").ignoresSafeArea()
                
                // Show message if there are no items in the favorites list
                if items.isEmpty {
                    Text("Press and hold on classes or professors to favorite them")
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding()
                } else {
                    // List to display each favorited item
                    List {
                        ForEach(items) { item in
                            ZStack(alignment: .trailing) {
                                // Background rectangle with shadow for each favorited item
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.white)
                                    .shadow(color: Color("PrimaryDarkPurple").opacity(0.15), radius: 4, x: 0, y: 2)
                                    .frame(maxWidth: .infinity)
                                
                                HStack {
                                    // Display appropriate icon for class or professor with yellow color for favorites
                                    Image(systemName: item.isClass ? "book.fill" : "person.fill")
                                        .foregroundColor(.yellow)
                                        .font(.system(size: 24))

                                    // Display the class or professor name with fallback text if nil
                                    Text(item.isClass
                                         ? (item.csClassName ?? "Unknown Class")
                                         : (item.professorName ?? "Unknown Professor"))
                                        .font(.headline)
                                        .foregroundColor(Color("PrimaryDarkPurple"))

                                    Spacer()

                                    // Chevron icon indicating navigability to a detailed view of the item
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
                                // Navigation link to detailed ClassView or ProfessorView based on item type
                                NavigationLink("", destination: item.isClass
                                    ? AnyView(ClassView(
                                        className: item.csClassName ?? "Unknown Class",
                                        about: item.about ?? "No description available",
                                        professorName: item.professorName ?? "Unknown Professor"
                                    ))
                                    : AnyView(ProfessorView(
                                        professorName: item.professorName ?? "Unknown Professor",
                                        about: item.about ?? "No description available",
                                        image: item.imageName != nil ? Image(item.imageName!) : nil
                                    ))
                                )
                                .opacity(0) // Hide the navigation link to maintain custom layout
                            )
                            .listRowBackground(Color.clear) // Set row background to transparent
                            .padding(.vertical, 6)
                        }
                        .onDelete(perform: deleteItems) // Attach delete function for swipe-to-delete functionality
                    }
                    .listStyle(InsetGroupedListStyle()) // Apply inset grouped list style for appearance
                    .scrollContentBackground(.hidden) // Hide the default list background color
                    .background(Color("PrimaryDarkPurple")) // Set custom background color
                }
            }
        }
    }

    /// Deletes the selected items from Core Data based on provided offsets.
    /// - Parameter offsets: The index set of items selected for deletion.
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            // Loop through the selected offsets and delete each item from Core Data
            offsets.map { items[$0] }.forEach(viewContext.delete)

            // Save the context to persist the changes, handling potential errors
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}
