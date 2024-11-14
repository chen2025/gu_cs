import CoreData
import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    var appData = ApplicationData()

    var body: some View {
        TabView {
            ClassesView(csList: appData.userData)
                .tabItem {
                    Label("Classes", systemImage: "studentdesk")
                }
            ProfessorsView(csList: appData.userData)
                .tabItem {
                    Label("Professors", systemImage: "person.3")
                }
            FavoritesView()
                .tabItem {
                    Label("Favorites", systemImage: "star")
                }
        }
    }
}

#Preview {
    ContentView().environment(
        \.managedObjectContext, PersistenceController.preview.container.viewContext)
}
