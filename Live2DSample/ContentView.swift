//
//  ContentView.swift
//  Live2DSample
//
//  Created by subdiox on 2024/03/24.
//

import SwiftUI
import SwiftData
import Live2DMetalObjC
import WidgetKit
let screenWidth = UIScreen.main.bounds.width
let screenHeight = UIScreen.main.bounds.height
//CubismModelSettingJsonファイル GetMotionCount関数めーちゃ大事な
//CubismModelSettingJson.
// ContentView の定義
struct ContentView: View {
    @AppStorage("CharacterSelect") var CharacterSelect: String = "HiragiMikuro"
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
    @State var talk = "";
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                ZStack {
                    // 背景画像
                    Image("\(CharacterSelect)Text")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: geometry.size.width * 1.1)
                        .position(x: geometry.size.width / 2, y: geometry.size.height / 5)
                    
                    // Live2DView の表示
                    HiragiMikuroView()
                        .shadow(color: Color("\(CharacterSelect)Color"), radius: 0, x: -7, y: 0)
                        .frame(width: geometry.size.width * 1.1, height: geometry.size.height * 1.1)
                        .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                    
                    ZStack {
                        
                           
                        
                        Image("\(CharacterSelect)PathBack")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: geometry.size.width / 2)
                            .offset(x: -7, y: 7)
                        Image("\(CharacterSelect)Path")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: geometry.size.width / 2)
                        VStack {
                            Spacer().frame(height: geometry.size.height / 55)
                            HStack {
                                Spacer().frame(width: geometry.size.width / 13)
                                Rectangle()
                                    .frame(width: 2, height: geometry.size.width / 28.5)
                                    .foregroundColor(Color("\(CharacterSelect)Color"))
                                Spacer().frame(width: geometry.size.width / 150)
                                Text("柊ミロク")
                                    .font(.custom("SFProDisplay-Bold", size: geometry.size.width / 28.5))
                                    .foregroundColor(Color("MainColor"))
                                    
                                Spacer()
                            }
              
                            Spacer().frame(height: geometry.size.height / 260)
                            HStack {
                                Spacer().frame(width: geometry.size.width / 17)
                                Text(talk)
                                    .font(.custom("SFProDisplay-Bold", size: geometry.size.width / 32))
                                    .foregroundColor(Color("MainColor"))
                                    .frame(width: geometry.size.width / 2.7)
                                Spacer()
                            }
                            
                            Spacer()
                        }
                        
                        
                    }
                    .frame(width: geometry.size.width / 2, height: (geometry.size.width / 2) / 1.8697)
                    .position(x: geometry.size.width / 1.5, y: geometry.size.height * 0.4)
                    
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
                if let randomItem = HiragiMirokuRandomTalk.randomElement() {
                    talk = randomItem
                } else {
                    print("配列が空です。")
                }
                for task in todos.filter({ (!$0.isDone && $0.isHide) }).prefix(3) {
                    print(task.isDone, task.isHide, task.content)
                }
                print("#######################################")
                for task in todos {
                    print(task.isDone, task.isHide, task.content)
                }

            }
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }
    
    // 新しい Todo を追加する処理
    private func addNewTodo() {
        
        let newTodo = Todo(content: inputText, isDone: false, isHide: true)
        context.insert(newTodo)
        try? context.save()
        WidgetCenter.shared.reloadAllTimelines()
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
            WidgetCenter.shared.reloadAllTimelines()
            self.editingTodo = nil  // 編集を終了
        }
    }
    
    private func deleteCompletedTodos() {
        let complete = todos.filter { $0.isDone }
        for todo in complete {
            context.delete(todo)
        }
        try? context.save()
        WidgetCenter.shared.reloadAllTimelines()
    }
    
    private func deleteAllTodos() {
        for todo in todos {
            context.delete(todo)
        }
        try? context.save()
        WidgetCenter.shared.reloadAllTimelines()
    }
}

