import CoreData
import SwiftUI

// View for displaying and managing favorited items (classes)
struct FavoritesView: View {
    @Environment(\.managedObjectContext) private var viewContext // Environment property for Core Data context
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.csClassName, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item> // Fetch request to retrieve favorited items from Core Data, sorted by class name
    
    // Track the edit mode state to handle deletion mode in the list
    @State private var editMode: EditMode = .inactive

    var body: some View {
        // Main navigation stack for the view
        NavigationStack {
            ZStack {
                // Set background color for the entire view
                Color("PrimaryDarkPurple").ignoresSafeArea()
                
                // Display message if there are no items in favorites
                if items.isEmpty {
                    Text("Press and hold on classes to favorite them")
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding()
                } else {
                    // List to display each favorited item
                    List {
                        ForEach(items) { item in
                            ZStack(alignment: .trailing) {
                                // Background rectangle with shadow for each list item
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.white)
                                    .shadow(color: Color("PrimaryDarkPurple").opacity(0.15), radius: 4, x: 0, y: 2)
                                    .frame(maxWidth: .infinity)
                                
                                HStack {
                                    // Display appropriate icon based on item type (class or professor) with color
                                    Image(systemName: item.isClass ? "book.fill" : "person.crop.circle.fill")
                                        .foregroundColor(item.isClass ? .yellow : .green)
                                        .font(.system(size: 24))

                                    // Display class or professor name with headline font
                                    Text(item.isClass
                                         ? (item.csClassName ?? "Unknown Class")
                                         : (item.professorName ?? "Unknown Professor"))
                                        .font(.headline)
                                        .foregroundColor(Color("PrimaryDarkPurple"))

                                    Spacer()

                                    // Chevron icon for navigation indication
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(Color("PrimaryDarkPurple"))
                                        .font(.system(size: 18))
                                        .padding(.trailing, 10)
                                }
                                .padding(.vertical, 12)
                                .padding(.horizontal, 16)
                                .frame(maxWidth: .infinity)
                                .background(
                                    // Background rectangle for the content with shadow
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color.white)
                                        .shadow(color: Color("PrimaryDarkPurple").opacity(0.15), radius: 4, x: 0, y: 2)
                                )
                            }
                            .padding(.horizontal, 4)
                            .background(
                                // Navigation link to navigate to either ClassView or ProfessorView based on item type
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
                                .opacity(0) // Make the navigation link transparent to keep custom layout
                            )
                            .listRowBackground(Color.clear) // Clear background for list rows
                            .padding(.vertical, 6)
                        }
                        .onDelete(perform: deleteItems) // Attach delete function for swipe-to-delete functionality
                    }
                    .listStyle(InsetGroupedListStyle()) // Apply list style for grouped appearance
                    .scrollContentBackground(.hidden) // Hide the default list background
                    .background(Color("PrimaryDarkPurple")) // Custom background color for the list
                }
            }
        }
    }

    // Function to delete selected items from Core Data
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            // Delete each selected item from Core Data based on the provided offsets
            offsets.map { items[$0] }.forEach(viewContext.delete)

            // Save the context to persist changes
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

#Preview {
    FavoritesView()
}
