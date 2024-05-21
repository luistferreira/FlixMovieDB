import SwiftUI

@main
struct FlixDbApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationView {
                HomeView(viewModel: HomeViewModel())
            }
            .tint(.white)
            .navigationViewStyle(StackNavigationViewStyle())
        }
    }
}
