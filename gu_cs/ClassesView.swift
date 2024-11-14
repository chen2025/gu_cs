import CoreData
import SwiftUI

struct ClassesView: View {
    @Environment(\.managedObjectContext) private var viewContext
    var csList: [CS]

    var body: some View {
        NavigationStack {
            List {
                ForEach(csList.filter { $0.isClass }) { cs in
                    NavigationLink {
                        ClassView(
                            className: cs.csClassName ?? "Unknown Class",
                            about: cs.about,
                            professorName: cs.professorName ?? "Unknown Professor"
                        )
                    } label: {
                        Text(cs.csClassName ?? "Unknown Class")
                    }
                    .gesture(
                        LongPressGesture(minimumDuration: 3)
                            .onEnded { _ in
                                let newItem = Item(context: viewContext)
                                newItem.csClassName = cs.csClassName
                                newItem.isClass = cs.isClass
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
                    )
                }
            }
        }
    }
}

#Preview {
    ClassesView(csList: ApplicationData().userData)
}
