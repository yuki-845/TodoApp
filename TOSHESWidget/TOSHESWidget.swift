import WidgetKit
import SwiftUI
import SwiftData

struct TaskWidgetEntryView: View {
    var entry: Provider.Entry
    @Environment(\.widgetFamily) var family // ウィジェットのファミリーを取得
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                if family == .systemSmall {
                    Image(uiImage: UIImage(named: "SmallorBig") ?? UIImage())
                        .resizable()
                        .scaledToFill()
                        .frame(width: geometry.size.width * 1.3, height: geometry.size.height * 1.3)
                        .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                    VStack(alignment: .leading, spacing: 6) {
                        
                        ForEach(entry.taskList.prefix(5), id: \.id) { task in
                            HStack {
                                Button(intent: TaskIntent(id: task.id.uuidString)) {
                                    Image(systemName: task.isDone ? "checkmark.circle.fill" : "circle")
                                        .foregroundStyle(Color("MainColor"))
                                        
                                }
                                .buttonStyle(.plain)
                                VStack {
                                    Text(task.content)
                                        .strikethrough(task.isDone)
                                        .foregroundColor(Color("MainColor"))
                                        .lineLimit(1)
                                }
                            }
                            
                        }
                    }
                    
                    
                } else if family == .systemMedium {
                    
                    Image(uiImage: UIImage(named: "Medium") ?? UIImage())
                        .resizable()
                        .scaledToFill()
                        .frame(width: geometry.size.width * 1.3, height: geometry.size.height * 1.3)
                        .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                    VStack(alignment: .leading, spacing: 6) {
                        
                        ForEach(entry.taskList.prefix(5), id: \.id) { task in
                            HStack {
                                Button(intent: TaskIntent(id: task.id.uuidString)) {
                                    Image(systemName: task.isDone ? "checkmark.circle.fill" : "circle")
                                        .foregroundStyle(Color("MainColor"))
                                        
                                }
                                .buttonStyle(.plain)
                                VStack {
                                    Text(task.content)
                                        .strikethrough(task.isDone)
                                        .foregroundColor(Color("MainColor"))
                                        .lineLimit(1)
                                }
                            }
                            
                        }
                    }
                    
                   
                } else if family == .systemLarge {
                    
                    Image(uiImage: UIImage(named: "SmallorBig") ?? UIImage())
                        .resizable()
                        .scaledToFill()
                        .frame(width: geometry.size.width * 1.3, height: geometry.size.height * 1.3)
                        .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                    VStack(alignment: .leading, spacing: 6) {
                        
                        ForEach(entry.taskList.prefix(10), id: \.id) { task in
                            HStack {
                                Button(intent: TaskIntent(id: task.id.uuidString)) {
                                    Image(systemName: task.isDone ? "checkmark.circle.fill" : "circle")
                                        .foregroundStyle(Color("MainColor"))
                                        
                                }
                                .buttonStyle(.plain)
                                VStack {
                                    Text(task.content)
                                        .strikethrough(task.isDone)
                                        .foregroundColor(Color("MainColor"))
                                        .lineLimit(1)
                                }
                            }
                            
                        }
                    }
                    
                }
                else {
                    VStack(alignment: .leading, spacing: 6) {
                        
                        ForEach(entry.taskList.prefix(3), id: \.id) { task in
                            HStack {
                                Button(intent: TaskIntent(id: task.id.uuidString)) {
                                    Image(systemName: task.isDone ? "checkmark.circle.fill" : "circle")
                                        .foregroundStyle(Color("MainColor"))
                                        
                                }
                                .buttonStyle(.plain)
                                VStack {
                                    Text(task.content)
                                        .strikethrough(task.isDone)
                                        .foregroundColor(Color("MainColor"))
                                        .lineLimit(1)
                                }
                            }
                            
                        }
                    }
                }
                
                
                
                
            }
            .containerBackground(Color.white, for: .widget)
            
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
        .supportedFamilies(supportedFamilies)
    }
    private var supportedFamilies: [WidgetFamily] {
            if #available(iOSApplicationExtension 16.0, *) {
                return [
                    .systemSmall,
                    .systemMedium,
                    .systemLarge,
                    .systemExtraLarge,
                    .accessoryRectangular
                ]
            } else {
                return [
                    .systemSmall,
                    .systemMedium,
                    .systemLarge
                ]
            }
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
        // タスクリストを取得
            let taskList = fetchTodos()
            // 現在の時刻
            let currentDate = Date()

            // 最初のエントリ（すぐに表示される）
            let initialTaskList = taskList.filter { !$0.isDone || !$0.isHide }  // 完了したタスクを非表示にする
            let initialEntry = TaskEntry(date: currentDate, taskList: initialTaskList)

            // 1.5秒後に更新されるエントリ
            let nextUpdateDate = currentDate.addingTimeInterval(0.2)
            
            // 1.5秒後には、完了したタスクをリストから除外
            let updatedTaskList = taskList.filter { !$0.isDone }  // 完了したタスクを非表示にする
            let updatedEntry = TaskEntry(date: nextUpdateDate, taskList: updatedTaskList)

            // タイムラインを作成して2つのエントリを追加
            let timeline = Timeline(entries: [initialEntry, updatedEntry], policy: .after(nextUpdateDate))

            // タイムラインを返す
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
