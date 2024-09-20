import SwiftUI
import WidgetKit
import AppIntents
import SwiftData

struct TaskIntent: AppIntent {
    static var title: LocalizedStringResource = "taskIntent"
    
    @Parameter(title: "id")
    var id: String

    // 初期化メソッド
    init() { }

    init(id: String) {
        self.id = id
    }

    // performメソッドでタスクの完了状態をトグル
    func perform() async throws -> some IntentResult {
        // StringからUUIDに変換
        guard let taskId = UUID(uuidString: id) else {
            throw NSError(domain: "Invalid UUID format", code: -1, userInfo: nil)
        }

        let context = ModelContext(sharedModelContainer)

        // タスクの検索
        let fetchDescriptor = FetchDescriptor<Todo>(predicate: #Predicate { $0.id == taskId })
        
        do {
            // 該当タスクの取得
            let todos = try context.fetch(fetchDescriptor)
            
            // タスクが存在する場合、完了状態をトグル
            if let todo = todos.first {
                todo.isDone.toggle()
                try context.save() // SwiftDataで保存
                WidgetCenter.shared.reloadAllTimelines() // ウィジェットの更新
               
            }
        } catch {
            print("タスクの状態変更に失敗しました: \(error)")
        }

        return .result()
    }
}
