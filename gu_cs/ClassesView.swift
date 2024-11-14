import CoreData
import SwiftUI

// View for displaying a list of classes
struct ClassesView: View {
    @Environment(\.managedObjectContext) private var viewContext // Environment property for Core Data context
    var csList: [CS] // Array of classes to display

    // Fetch favorited items from Core Data to dynamically track favorites
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.csClassName, ascending: true)],
        animation: .default)
    private var favoritedItems: FetchedResults<Item>
    
    @State private var savedItemID: UUID? // State variable for tracking the most recently saved item's ID

    var body: some View {
        // Main navigation stack for the view
        NavigationStack {
            ZStack {
                // Set background color for entire view
                Color("PrimaryDarkPurple").ignoresSafeArea()

                // List displaying each class from csList
                List {
                    ForEach(csList.filter { $0.isClass }) { cs in
                        ZStack(alignment: .trailing) {
                            // Rounded rectangle background for each list item
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.white)
                                .shadow(color: Color("PrimaryDarkPurple").opacity(0.15), radius: 4, x: 0, y: 2)
                                .frame(maxWidth: .infinity)
                            
                            // Horizontal stack for content within each class item
                            HStack {
                                // Book icon, changing color based on favorite status
                                Image(systemName: "book.fill")
                                    .foregroundColor(isAlreadyFavorited(cs: cs) ? .yellow : Color("PrimaryDarkPurple"))
                                    .font(.system(size: 24))
                                    .animation(.easeInOut(duration: 0.3), value: isAlreadyFavorited(cs: cs))

                                // Display class name
                                Text(cs.csClassName ?? "Unknown Class")
                                    .font(.headline)
                                    .foregroundColor(Color("PrimaryDarkPurple"))

                                Spacer()

                                // Chevron icon for list item
                                Image(systemName: "chevron.right")
                                    .foregroundColor(Color("PrimaryDarkPurple"))
                                    .font(.system(size: 18))
                                    .padding(.trailing, 10)
                            }
                            .padding(.vertical, 12)
                            .padding(.horizontal, 16)
                            .frame(maxWidth: .infinity)
                            .background(
                                // Background rectangle with shadow for list item
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.white)
                                    .shadow(color: Color("PrimaryDarkPurple").opacity(0.15), radius: 4, x: 0, y: 2)
                            )
                        }
                        .padding(.horizontal, 4)
                        .background(
                            // Navigation link to ClassView, allowing navigation to class details
                            NavigationLink("", destination: ClassView(
                                className: cs.csClassName ?? "Unknown Class",
                                about: cs.about,
                                professorName: cs.professorName ?? "Unknown Professor"
                            ))
                            .opacity(0)
                        )
                        .listRowBackground(Color.clear) // Transparent row background
                        .padding(.vertical, 6)
                        .gesture(
                            // Long press gesture to save class as favorite if not already favorited
                            LongPressGesture(minimumDuration: 2)
                                .onEnded { _ in
                                    if !isAlreadyFavorited(cs: cs) {
                                        saveToFavorites(cs: cs)
                                        savedItemID = cs.id
                                    }
                                }
                        )
                    }
                }
                .scrollContentBackground(.hidden) // Hide list background
                .background(Color("PrimaryDarkPurple")) // Set custom background color
            }
            .listStyle(InsetGroupedListStyle()) // List style
        }
    }

    // Function to save a class to favorites in Core Data
    private func saveToFavorites(cs: CS) {
        let newItem = Item(context: viewContext)
        newItem.csClassName = cs.csClassName // Set class name
        newItem.isClass = cs.isClass // Set item type
        newItem.professorName = cs.professorName // Set professor name
        newItem.about = cs.about // Set class description
        newItem.imageName = cs.imageName // Set associated image name

        // Save new favorite item to Core Data, handling potential errors
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }

    // Function to check if a class is already favorited
    private func isAlreadyFavorited(cs: CS) -> Bool {
        // Check if favorited items contain the class name
        return favoritedItems.contains { $0.csClassName == cs.csClassName }
    }
}
