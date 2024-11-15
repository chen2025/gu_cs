import CoreData
import SwiftUI

struct ProfessorsView: View {
    @Environment(\.managedObjectContext) private var viewContext
    var csList: [CS]

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.professorName, ascending: true)],
        animation: .default)
    private var favoritedItems: FetchedResults<Item>

    var body: some View {
        NavigationStack {
            ZStack {
                Color("PrimaryDarkPurple").ignoresSafeArea()

                List {
                    ForEach(csList.filter { !$0.isClass }) { cs in
                        ZStack(alignment: .trailing) {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.white)
                                .shadow(color: Color("PrimaryDarkPurple").opacity(0.15), radius: 4, x: 0, y: 2)
                                .frame(maxWidth: .infinity)
                            
                            HStack {
                                Image(systemName: "person.fill")
                                    .foregroundColor(isAlreadyFavorited(cs: cs) ? .yellow : Color("PrimaryDarkPurple"))
                                    .font(.system(size: 24))
                                    .animation(.easeInOut(duration: 0.3), value: isAlreadyFavorited(cs: cs))

                                Text(cs.professorName ?? "Unknown Professor")
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
                            NavigationLink("", destination: ProfessorView(
                                professorName: cs.professorName ?? "Unknown Professor",
                                about: cs.about,
                                image: cs.image
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
        newItem.professorName = cs.professorName
        newItem.isClass = false
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
        return favoritedItems.contains { !$0.isClass && $0.professorName == cs.professorName }
    }
}
