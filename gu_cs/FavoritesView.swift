import CoreData
import SwiftUI

struct FavoritesView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.csClassName, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>
    
    @State private var editMode: EditMode = .inactive

    var body: some View {
        NavigationStack {
            ZStack {
                Color("PrimaryDarkPurple").ignoresSafeArea()
                
                if items.isEmpty {
                    Text("Press and hold on classes or professors to favorite them")
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding()
                } else {
                    List {
                        ForEach(items) { item in
                            ZStack(alignment: .trailing) {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.white)
                                    .shadow(color: Color("PrimaryDarkPurple").opacity(0.15), radius: 4, x: 0, y: 2)
                                    .frame(maxWidth: .infinity)
                                
                                HStack {
                                    // Display appropriate icon based on item type (class or professor) with yellow color
                                    Image(systemName: item.isClass ? "book.fill" : "person.fill")
                                        .foregroundColor(.yellow)
                                        .font(.system(size: 24))

                                    Text(item.isClass
                                         ? (item.csClassName ?? "Unknown Class")
                                         : (item.professorName ?? "Unknown Professor"))
                                        .font(.headline)
                                        .foregroundColor(Color("PrimaryDarkPurple"))

                                    Spacer()

                                    Image(systemName: "chevron.right")
                                        .foregroundColor(Color("PrimaryDarkPurple"))
                                        .font(.system(size: 18))
                                        .padding(.trailing, 10)
                                }
                                .padding(.vertical, 12)
                                .padding(.horizontal, 16)
                                .frame(maxWidth: .infinity)
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color.white)
                                        .shadow(color: Color("PrimaryDarkPurple").opacity(0.15), radius: 4, x: 0, y: 2)
                                )
                            }
                            .padding(.horizontal, 4)
                            .background(
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
                                .opacity(0)
                            )
                            .listRowBackground(Color.clear)
                            .padding(.vertical, 6)
                        }
                        .onDelete(perform: deleteItems)
                    }
                    .listStyle(InsetGroupedListStyle())
                    .scrollContentBackground(.hidden)
                    .background(Color("PrimaryDarkPurple"))
                }
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
