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

        // すべてのタスクの検索（isHideを変更するため）
        let fetchDescriptorAllTodos = FetchDescriptor<Todo>()

        // 特定のタスクを検索（isDoneを変更するため）
        let fetchDescriptorSingleTodo = FetchDescriptor<Todo>(predicate: #Predicate { $0.id == taskId })

        do {
            // すべてのタスクを取得し、isHideをトグル
            let allTodos = try context.fetch(fetchDescriptorAllTodos)
            for todo in allTodos {
                todo.isHide = true
            }
            
            // 変更を保存
            try context.save()
            
            // ウィジェットの更新
            WidgetCenter.shared.reloadAllTimelines()
            
            // 特定のタスクを取得し、isDoneをトグル
            let todos = try context.fetch(fetchDescriptorSingleTodo)
            if let todo = todos.first {
                todo.isDone.toggle()
                todo.isHide.toggle()
                // 変更を保存
                try context.save()
                
                // ウィジェットの更新
                WidgetCenter.shared.reloadAllTimelines()
            }
        } catch {
            print("タスクの状態変更に失敗しました: \(error)")
        }
        return .result()
    }
}
