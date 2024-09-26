import SwiftUI
import Live2DMetalObjC

@main
struct Live2DSampleApp: App {
    @Environment(\.scenePhase) var scenePhase
    @StateObject private var characterManager = CharacterManager()
    init() {
        L2DCubism.initialize()
        
    }

    var body: some Scene {
        WindowGroup {
            TabeView()
                .modelContainer(for: Todo.self)
                .environmentObject(characterManager)
        }
        .onChange(of: scenePhase) { newPhase in
            if newPhase == .background {
                // アプリがバックグラウンドに入ったときにCubismのリソースを解放
                
            }
            if newPhase == .active {
                               
            }
        }
    }
}
