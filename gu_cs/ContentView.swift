import SwiftUI
import CoreData

// Main ContentView for the application
struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext // Environment property for Core Data context
    var appData = ApplicationData() // Application data instance for managing user data
    
    init() {
        // Set up the UITabBarAppearance to make the tab bar background solid white
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()
        tabBarAppearance.backgroundColor = UIColor.white

        UITabBar.appearance().standardAppearance = tabBarAppearance
        if #available(iOS 15.0, *) {
            UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        }
    }

    var body: some View {
        ZStack {
            // Set the main background color to dark purple, covering the safe area
            Color("PrimaryDarkPurple").ignoresSafeArea()

            VStack(spacing: 0) {
                // Top bar displaying the main title with a white background and dark purple text
                VStack {
                    Text("Explore Georgetown University's Computer Science Department")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(Color("PrimaryDarkPurple"))
                        .multilineTextAlignment(.center)
                        .padding(.top, 10)
                        .padding(.bottom, 5)

                    Divider() // Horizontal divider below the title
                        .background(Color.gray.opacity(0.5))
                        .padding(.horizontal)
                }
                .background(Color.white) // Set top bar background to white

                // Tab view for navigation between different sections
                TabView {
                    // Tab for viewing classes
                    ClassesView(csList: appData.userData)
                        .tabItem {
                            VStack {
                                Image(systemName: "studentdesk")
                                Text("Classes")
                            }
                        }
                    
                    // Tab for viewing professors
                    ProfessorsView(csList: appData.userData)
                        .tabItem {
                            VStack {
                                Image(systemName: "person.3")
                                Text("Professors")
                            }
                        }

                    // Tab for viewing favorite classes and professors
                    FavoritesView()
                        .tabItem {
                            VStack {
                                Image(systemName: "star.fill")
                                Text("Favorites")
                            }
                        }
                }
                .accentColor(Color("PrimaryDarkPurple")) // Set tab icons and text to dark purple
                .background(Color.white) // Set TabView background to white
            }
        }
    }
}

#Preview {
    ContentView().environment(
        \.managedObjectContext, PersistenceController.preview.container.viewContext)
}
