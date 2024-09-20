import WidgetKit
import SwiftUI
import SwiftData

struct TaskWidgetEntryView: View {
    var entry: Provider.Entry
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 6) {
                ForEach(entry.taskList) { task in
                    HStack {
                        Button(intent: TaskIntent(id: task.id.uuidString)) {
                            
                            Image(systemName: task.isDone ? "checkmark.circle.fill" : "circle")
                                .foregroundStyle(.blue)
                        }
                        .buttonStyle(.plain)
                        VStack {
                            Text(task.content)
                                .strikethrough(task.isDone)
                        }
                    }
                }
            }
        }
        .containerBackground(.fill.tertiary, for: .widget)
    }
    
    // タスク完了状態の切り替え
    private func toggleTaskCompletion(task: Todo) {
        let context = ModelContext(sharedModelContainer)
        task.isDone.toggle()
        do {
            try context.save()
            WidgetCenter.shared.reloadAllTimelines() // ウィジェットの更新
        } catch {
            print("タスク完了状態の保存に失敗しました: \(error)")
        }
    }
}

struct TaskEntry: TimelineEntry {
    let date: Date
    let taskList: [Todo]
}

struct TaskWidget: Widget {
    let kind: String = "TaskWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            TaskWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Task Widget")
        .description("Todoタスクの一覧を表示するウィジェットです。")
    }
}

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> TaskEntry {
        // プレースホルダーは必ず空のリストを返す
        TaskEntry(date: Date(), taskList: [])
    }

    func getSnapshot(in context: Context, completion: @escaping (TaskEntry) -> ()) {
        // スナップショットでのデータ取得
        let entry = TaskEntry(date: Date(), taskList: fetchTodos())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<TaskEntry>) -> ()) {
        // ウィジェットのタイムラインの作成
        let taskList = fetchTodos()
            
            // エントリの作成
            let entry = TaskEntry(date: Date(), taskList: taskList)
            
            // 5分後に再度更新されるようにタイムラインを設定
            let nextUpdateDate = Calendar.current.date(byAdding: .minute, value: 5, to: Date())!
            
            // タイムラインを作成し、次回の更新時刻を指定
            let timeline = Timeline(entries: [entry], policy: .after(nextUpdateDate))
            
            completion(timeline)
    }

    // SwiftDataを使ってTodoリストを取得
    private func fetchTodos() -> [Todo] {
        let context = ModelContext(sharedModelContainer)
        do {
            let todos = try context.fetch(FetchDescriptor<Todo>())
            return todos
        } catch {
            print("Todoの取得に失敗しました: \(error)")
            return []
        }
    }
}
