import CoreData
import SwiftUI

struct FavoritesView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.csClassName, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>

    var body: some View {
        NavigationView {
            List {
                ForEach(items) { item in
                    NavigationLink {
                        if item.isClass {
                            ClassView(
                                className: item.csClassName ?? "Unknown Class",
                                about: item.about ?? "No description available",
                                professorName: item.professorName ?? "Unknown Professor"
                            )
                        } else {
                            ProfessorView(
                                professorName: item.professorName ?? "Unknown Professor",
                                about: item.about ?? "No description available",
                                image: item.imageName != nil ? Image(item.imageName!) : nil
                            )
                        }
                    } label: {
                        Text(
                            item.isClass
                                ? (item.csClassName ?? "Unknown Class")
                                : (item.professorName ?? "Unknown Professor"))
                    }
                }
                .onDelete(perform: deleteItems)
            }
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)

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
