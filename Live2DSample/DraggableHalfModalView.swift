import SwiftUI
import WidgetKit
import SwiftData


struct DraggableHalfModalView: View {
    @Binding var isPresented: Bool
    @Binding var inputText: String
    var isTextFieldFocused: FocusState<Bool>.Binding
    @GestureState private var dragOffset = CGSize.zero
    @State private var currentOffset: CGFloat = UIScreen.main.bounds.height / 2
    @Environment(\.modelContext) private var context
    @Query(sort: \Todo.registerDate, order: .reverse) private var todos: [Todo]
    @Binding var editingTodo: Todo?  // 編集中の Todo
    @Binding var isNewTodo: Bool  // 新しい Todo 作成中のフラグ
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                VStack {
                    dragHandle(geometry: geometry)
                    
                    ScrollView(showsIndicators: false) {
                        todoListView(geometry: geometry)
                        Spacer().frame(height: geometry.size.height / 1.5)
                    }
                    
                }
                .onAppear {
                    currentOffset = geometry.size.height // モーダルの初期位置
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .background(Color.white)
            .cornerRadius(20)
            .shadow(radius: 10)
            .padding(.horizontal)
            .background(Color.clear)
            .position(x: geometry.size.width / 2, y: dragOffset.height + currentOffset)
        }
    }
    
    // ドラッグハンドルのVStackを分離
    private func dragHandle(geometry: GeometryProxy) -> some View {
        VStack {
            Spacer().frame(height: geometry.size.width * 0.04)
            HStack {
                Spacer().frame(width: geometry.size.width * 0.03 + geometry.size.width * 0.02)
                Text("TODO LIST")
                    .font(.custom("SFProDisplay-HeavyItalic", size: geometry.size.width / 13))
                    .foregroundColor(Color("MainColor"))
                Spacer()
            }
            Spacer().frame(height: geometry.size.width * 0.04)
        }
        .contentShape(Rectangle())
        .gesture(
            DragGesture()
                .updating($dragOffset) { value, state, _ in
                    state = value.translation
                }
                .onEnded { value in
                    handleDragEnd(value: value, geometry: geometry)
                }
        )
    }
    
    // ドラッグの終了処理を分離
    private func handleDragEnd(value: DragGesture.Value, geometry: GeometryProxy) {
        if value.translation.height < geometry.size.height * 0.08 {
            if currentOffset == geometry.size.height {
                currentOffset = geometry.size.height / 1.4
            }
        } else if value.translation.height > geometry.size.height * 0.08 {
            if currentOffset < geometry.size.height {
                currentOffset = geometry.size.height
            }
        }
    }
    
    // TODOリストの表示を分離
    private func todoListView(geometry: GeometryProxy) -> some View {
        VStack(spacing: geometry.size.height * 0.01) {
            ForEach(Array(todos.enumerated()), id: \.element.id) { index, todo in
                todoItemView(todo: todo, index: index, geometry: geometry)
            }
        }
    }
    
    // TODO項目の表示を分離
    private func todoItemView(todo: Todo, index: Int, geometry: GeometryProxy) -> some View {
        VStack {
            Spacer().frame(height: geometry.size.width * 0.03)
            HStack {
                Spacer().frame(width: geometry.size.width * 0.03)
                ZStack {
                    Button {
                        check(index: index)
                    } label: {
                        ZStack {
                            Circle()
                                .fill(Color("SubColor"))
                                .overlay(
                                    Circle()
                                        .stroke(Color("MainColor"), lineWidth: 1)
                                )
                                .frame(width: geometry.size.width / 20, height: geometry.size.width / 20)
                            if(todo.isDone) {
                                Image(systemName: "checkmark")
                                    .font(.title3)
                                    .scaleEffect(0.7)
                                    .foregroundColor(Color("MainColor"))
                            }
                        }
                    }
                }
                Text(todo.content)
                    .strikethrough(todo.isDone, color: Color("MainColor"))  // 取り消し線を引く
                    .font(.custom("SFProDisplay-Bold", size: geometry.size.width / 22))
                    .foregroundColor(Color("MainColor"))
                Spacer()
            }
            Spacer().frame(height: geometry.size.width * 0.03)
        }
        .frame(width: geometry.size.width * 0.9)
        .background(Color("SubColor"))
        .cornerRadius(8)
        .contentShape(Rectangle())
        .onTapGesture {
            editingTodo = todo  // 編集モードに設定
            isTextFieldFocused.wrappedValue = true  // テキストフィールドにフォーカスを設定
            print("チェックボックス外だよー")
        }
    }
    
    // チェック状態の更新
    private func check(index: Int) {
        todos[index].isDone.toggle()
        
        
        do {
            try context.save() // SwiftDataで保存
        } catch {
            print("Error saving data: \(error)") // 保存失敗時のエラーハンドリング
        }
        WidgetCenter.shared.reloadAllTimelines()
    }
}
