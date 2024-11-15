import CoreData
import SwiftUI

struct ClassesView: View {
    @Environment(\.managedObjectContext) private var viewContext
    var csList: [CS]

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.csClassName, ascending: true)],
        animation: .default)
    private var favoritedItems: FetchedResults<Item>
    
    @State private var savedItemID: UUID?

    var body: some View {
        NavigationStack {
            ZStack {
                Color("PrimaryDarkPurple").ignoresSafeArea()

                List {
                    ForEach(csList.filter { $0.isClass }) { cs in
                        ZStack(alignment: .trailing) {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.white)
                                .shadow(color: Color("PrimaryDarkPurple").opacity(0.15), radius: 4, x: 0, y: 2)
                                .frame(maxWidth: .infinity)
                            
                            HStack {
                                Image(systemName: "book.fill")
                                    .foregroundColor(isAlreadyFavorited(cs: cs) ? .yellow : Color("PrimaryDarkPurple"))
                                    .font(.system(size: 24))
                                    .animation(.easeInOut(duration: 0.3), value: isAlreadyFavorited(cs: cs))

                                Text(cs.csClassName ?? "Unknown Class")
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
                            NavigationLink("", destination: ClassView(
                                className: cs.csClassName ?? "Unknown Class",
                                about: cs.about,
                                professorName: cs.professorName ?? "Unknown Professor"
                            ))
                            .opacity(0)
                        )
                        .listRowBackground(Color.clear)
                        .padding(.vertical, 6)
                        .gesture(
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
                .scrollContentBackground(.hidden)
                .background(Color("PrimaryDarkPurple"))
            }
            .listStyle(InsetGroupedListStyle())
        }
    }

    private func saveToFavorites(cs: CS) {
        let newItem = Item(context: viewContext)
        newItem.csClassName = cs.csClassName
        newItem.isClass = true
        newItem.professorName = cs.professorName
        newItem.about = cs.about
        newItem.imageName = cs.imageName

        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }

    private func isAlreadyFavorited(cs: CS) -> Bool {
        return favoritedItems.contains { $0.isClass && $0.csClassName == cs.csClassName }
    }
}
