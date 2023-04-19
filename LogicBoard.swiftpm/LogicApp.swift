import SwiftUI

@main
struct MyApp: App {
    let envi = LogicEnvironment()
    var body: some Scene {
        WindowGroup {
            BoardView()
                .environmentObject(envi)
        }
    }
}
