//
//  ContentView.swift
//  Live2DSample
//
//  Created by subdiox on 2024/03/24.
//

import SwiftUI
import SwiftData
let screenWidth = UIScreen.main.bounds.width
let screenHeight = UIScreen.main.bounds.height



// ContentView の定義
struct ContentView: View {
    @State private var isModalPresented = true
    @State private var isTextFieldVisible = false
    @State private var inputText = ""
    @FocusState private var isTextFieldFocused: Bool
    @StateObject private var keyboardResponder = KeyboardResponder()
    @State var isEnter = false
    @Environment(\.modelContext) private var context
    @Query private var todos: [Todo]
    @State private var showAlert = false  // アラートの表示フラグ
    @State private var editingTodo: Todo? = nil  // 編集中のTodo
    @State private var isNewTodo = false  // 新しいTodoを作成中かどうか

    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                ZStack {
                    // 背景画像
                    Image("RUKA")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: geometry.size.width)
                        .position(x: geometry.size.width / 2, y: geometry.size.height / 5)
                    
                    // Live2DView の表示
                    HiyoriView()
                        .shadow(color: Color.red, radius: 0, x: -7, y: 0)
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .position(x: geometry.size.width / 2, y: geometry.size.height / 2.2)
                    
                    // モーダル表示のビュー
                    DraggableHalfModalView(isPresented: $isModalPresented, inputText: $inputText, isTextFieldFocused: $isTextFieldFocused, editingTodo: $editingTodo, isNewTodo: $isNewTodo)
                        .transition(.move(edge: .bottom))
                        .animation(.easeInOut)
                    
                    // 編集用または新規用のテキストフィールドを表示
                    if let editingTodo = editingTodo {
                        TextField("Edit text", text: Binding(
                            get: { editingTodo.content },
                            set: { newValue in
                                self.editingTodo?.content = newValue
                            }
                        ))
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                        .focused($isTextFieldFocused)
                        .onSubmit {
                            saveTodoEdit()
                        }
                    } else if isNewTodo {
                        
                        TextField("New todo", text: $inputText)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding()
                            .focused($isTextFieldFocused)
                            .onSubmit {
                                if(inputText.isEmpty) {
                                    isNewTodo = false
                                    isTextFieldFocused = false
                                    isTextFieldVisible = false
                                }else {
                                    addNewTodo()
                                }
                                
                            }
                    }
                    
                    // プラスボタン
                    Button {
                        isTextFieldVisible = true
                        isNewTodo = true  // 新しいTodo作成モードに入る
                        isTextFieldFocused = true // キーボードを自動的に表示する
                    } label: {
                        ZStack {
                            Circle()
                                .fill(Color("MainColor"))
                                .frame(width: geometry.size.width / 8, height: geometry.size.width / 8)
                            Image(systemName: "plus")
                                .font(.title)
                                .foregroundColor(.white)
                        }
                    }
                    .position(x: geometry.size.width - ((geometry.size.width / 7) / 2 + geometry.size.width * 0.02),
                              y: geometry.size.height - ((geometry.size.width / 7) / 2 + geometry.size.width * 0.12))
                    
                    // 削除ボタン
                    Button {
                        let complete = todos.filter { $0.isDone }
                        
                        if complete.isEmpty {
                            showAlert = true
                        } else {
                            deleteCompletedTodos()
                        }
                    } label: {
                        ZStack {
                            Circle()
                                .fill(Color.white)
                                .overlay(
                                    Circle()
                                        .stroke(Color("MainColor"), lineWidth: 1)
                                )
                                .frame(width: geometry.size.width / 8, height: geometry.size.width / 8)
                            
                            Image(systemName: "trash")
                                .font(.title2)
                                .foregroundColor(todos.isEmpty ? Color.gray : Color("MainColor"))
                        }
                    }
                    .disabled(todos.isEmpty)  // todos が空のときはボタンを無効化
                    .position(x: geometry.size.width / 10,
                              y: geometry.size.height - ((geometry.size.width / 7) / 2 + geometry.size.width * 0.12))
                    .alert(isPresented: $showAlert) {
                        Alert(
                            title: Text("すべて削除しますか？"),
                            message: Text("この操作は取り消せません。"),
                            primaryButton: .destructive(Text("削除")) {
                                deleteAllTodos()
                            },
                            secondaryButton: .cancel()
                        )
                    }
                }
                Spacer()
            }
            .onTapGesture {
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                if isTextFieldFocused {
                    isTextFieldFocused = false
                    isTextFieldVisible = false
                    isNewTodo = false
                    editingTodo = nil
                }
            }
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }
    
    // 新しい Todo を追加する処理
    private func addNewTodo() {
        
        let newTodo = Todo(content: inputText, isDone: false)
        context.insert(newTodo)
        try? context.save()
        isNewTodo = true
        inputText = ""
        isTextFieldFocused = true
        isTextFieldVisible = true
    }
    
    // Todoを編集する処理
    private func saveTodoEdit() {
        isTextFieldFocused = false
        isTextFieldVisible = false
        if let editingTodo = editingTodo {
            try? context.save()  // 変更を保存
            self.editingTodo = nil  // 編集を終了
        }
    }
    
    private func deleteCompletedTodos() {
        let complete = todos.filter { $0.isDone }
        for todo in complete {
            context.delete(todo)
        }
        try? context.save()
    }
    
    private func deleteAllTodos() {
        for todo in todos {
            context.delete(todo)
        }
        try? context.save()
    }
}

#Preview {
    ContentView()
}
