import SwiftUI

@main
struct MyApp: App {
    @StateObject var environment = LogicEnvironment()
    var body: some Scene {
        WindowGroup {
            BoardView()
                .environmentObject(environment)
        }
    }
}
