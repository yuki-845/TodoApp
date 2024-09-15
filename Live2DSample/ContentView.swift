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


import SwiftUI

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
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                ZStack {
                    // 背景画像
                    Image("RUKA")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: geometry.size.width) // GeometryReaderの幅に合わせる
                        .position(x: geometry.size.width / 2, y: geometry.size.height / 5)
                    
                    // Live2DView の表示
                    Live2DView()
                        .shadow(color: Color.red, radius: 0, x: -7, y: 0)
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .position(x: geometry.size.width / 2, y: geometry.size.height / 2.2)
                    
                    // モーダル表示のビュー
                    DraggableHalfModalView(isPresented: $isModalPresented, inputText: $inputText)
                        .transition(.move(edge: .bottom))
                        .animation(.easeInOut)
                    
                    // プラスボタン
                    Button {
                        isTextFieldVisible = true
                        isTextFieldFocused = true // キーボードを自動的に表示する
                    } label: {
                        ZStack {
                            Circle()
                                .fill(Color("MainColor")) // 中身の色を設定
                                .frame(width: geometry.size.width / 8, height: geometry.size.width / 8)
                            Image(systemName: "plus")
                                .font(.title)
                                .foregroundColor(Color.white)
                        }
                        
                    }
                    .position(x: geometry.size.width - ((geometry.size.width / 7) / 2 + geometry.size.width * 0.02),
                              y: geometry.size.height - ((geometry.size.width / 7) / 2 + geometry.size.width * 0.12))
                    
                    Button {
                        let complete = todos.filter { $0.isDone }  // 完了済みの Todo をフィルタリング
                        
                        if complete.isEmpty {
                            // 全て削除のアラートを表示
                            showAlert = true
                        } else {
                            // 完了済みの Todo を削除
                            deleteCompletedTodos()
                        }
                    } label: {
                        ZStack {
                            Circle()
                                .fill(Color.white) // 中身の色を設定
                                .overlay(
                                    Circle()
                                        .stroke(Color("MainColor"), lineWidth: 1) // 枠線
                                )
                                .frame(width: geometry.size.width / 8, height: geometry.size.width / 8)
                            
                            Image(systemName: "trash")
                                .font(.title2)
                                .foregroundColor(todos.isEmpty ? Color.gray : Color("MainColor"))  // todos.isEmpty で
                        }
                    }
                    .disabled(todos.isEmpty)  // todos が空のときはボタンを無効化
                    .position(x: geometry.size.width / 10,
                              y: geometry.size.height - ((geometry.size.width / 7) / 2 + geometry.size.width * 0.12))
                    .alert(isPresented: $showAlert) {
                        // すべて削除の確認アラート
                        Alert(
                            title: Text("すべて削除しますか？"),
                            message: Text("この操作は取り消せません。"),
                            primaryButton: .destructive(Text("削除")) {
                                deleteAllTodos()  // すべての Todo を削除
                            },
                            secondaryButton: .cancel(Text("キャンセル"))
                        )
                    }
                    
                    // テキストフィールドの表示
                    if isTextFieldVisible {
                        TextField("Enter text", text: $inputText)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding()
                            .focused($isTextFieldFocused)
                            .onSubmit {
                                // エンターキーが押されたときの処理
                                print("エンターキーが押されました: \($inputText)")
                                isEnter = true
                                add(todo: inputText)
                                inputText = ""
                            }
                        
                    }
                }
                Spacer()
            }
            .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardDidShowNotification)) { _ in
                //self.state = "Opened"
            }.onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardDidHideNotification)) { _ in
                //self.state = "Closed"
                
                isEnter = false
            }
            .onTapGesture {
                // キーボードを閉じる
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                if(isTextFieldFocused) {
                    isTextFieldFocused = false
                    isTextFieldVisible = false
                    
                }
            }
        }
        .ignoresSafeArea(.keyboard, edges: .bottom) // キーボードのUIを無視
    }
    private func add(todo: String) {
        let data = Todo(content: todo, isDone: false)
        context.insert(data)
        
    }
    
    private func deleteCompletedTodos() {
        let complete = todos.filter { $0.isDone }  // 完了済みの Todo をフィルタリング
        for todo in complete {
            context.delete(todo)  // 完了済みの Todo を削除
        }
        try? context.save()  // 変更を保存
    }
    
    // すべての Todo を削除する関数
    private func deleteAllTodos() {
        
        for todo in todos {
            context.delete(todo)  // 各 Todo を削除
        }
        try? context.save()  // 変更を保存
    }
    
}


#Preview {
    ContentView()
}
