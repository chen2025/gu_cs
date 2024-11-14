import CoreData
import SwiftUI

struct ProfessorsView: View {
    @Environment(\.managedObjectContext) private var viewContext
    var csList: [CS]

    var body: some View {
        NavigationStack {
            List {
                ForEach(csList.filter { !$0.isClass }) { cs in
                    NavigationLink {
                        ProfessorView(
                            professorName: cs.professorName ?? "Unknown Professor",
                            about: cs.about,
                            image: cs.image
                        )
                    } label: {
                        Text(cs.professorName ?? "Unknown Professor")
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
    ProfessorsView(csList: ApplicationData().userData)
}
