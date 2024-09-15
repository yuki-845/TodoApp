import SwiftUI
import Live2DMetalObjC

@main
struct Live2DSampleApp: App {
    @Environment(\.scenePhase) var scenePhase

    init() {
        L2DCubism.initialize()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: Todo.self)
        }
        .onChange(of: scenePhase) { newPhase in
            if newPhase == .background {
                // アプリがバックグラウンドに入ったときにCubismのリソースを解放
                L2DCubism.dispose()
            }
        }
    }
}
