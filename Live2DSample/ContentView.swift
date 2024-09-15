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
struct DraggableHalfModalView: View {
    @Binding var isPresented: Bool
    @Binding var inputText: String
    
    @GestureState private var dragOffset = CGSize.zero
    @State private var currentOffset: CGFloat = UIScreen.main.bounds.height / 2
    @Environment(\.modelContext) private var context
    @Query(sort: \Todo.registerDate, order: .reverse) private var todos: [Todo]  // 昇順にソート
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                
                VStack {
                    // ドラッグハンドル部分
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
                    .gesture(
                        DragGesture()
                            .updating($dragOffset) { value, state, _ in
                                state = value.translation // ドラッグの現在のオフセットを取得
                            }
                            .onEnded { value in
                                if value.translation.height <  geometry.size.height * 0.08{
                                    // すでに上にいる場合は、上には動かさない
                                    if currentOffset == geometry.size.height {
                                        // 上に100以上ドラッグされたとき、モーダルを上に移動
                                        currentOffset = geometry.size.height / 1.4
                                    }
                                }
                                // 下方向にドラッグされたときの処理
                                else if value.translation.height > geometry.size.height * 0.08 {
                                    // すでに上にある場合は、下に戻す
                                    if currentOffset < geometry.size.height {
                                        currentOffset = geometry.size.height
                                    }
                                }
                            }
                    )
                    
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: geometry.size.height * 0.01) {
                            ForEach(Array(todos.enumerated()), id: \.element.id) { index, todo in
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
                                                        .fill(Color("SubColor")) // 中身の色を設定
                                                        .overlay(
                                                            Circle()
                                                                .stroke(Color("MainColor"), lineWidth: 1) // 枠線
                                                        )
                                                        .frame(width: geometry.size.width / 20, height: geometry.size.width / 20) // 円のサイズ
                                                    if(todo.isDone) {
                                                        Image(systemName: "checkmark")
                                                            .font(.title3)  // 元のフォントサイズ
                                                            .scaleEffect(0.7)  // 全体を 50% に縮小
                                                            .foregroundColor(Color("MainColor"))
                                                            
                                                    }
                                                }
                                            }
                                        }
                                        
                                        Text(todo.content)
                                            .font(.custom("SFProDisplay-Bold", size: geometry.size.width / 19))
                                            .foregroundColor(Color("MainColor"))
                                        
                                        Spacer()
                                    }
                                    Spacer().frame(height: geometry.size.width * 0.03)
                                }
                                .frame(width: geometry.size.width * 0.9)
                                .background(Color("SubColor"))
                                .cornerRadius(8)
                                .contentShape(Rectangle()) // タップ領域を明確にするために Rectangle を指定
                                .onTapGesture {
                                    print("チェックボックス外だよー") // VStack全体がタップ可能に
                                }
                                
                            }
                            Spacer()
                                .frame(height: geometry.size.height / 1.5)
                        }
                    } // ScrollView
                    
                }
                .onAppear {
                    currentOffset = geometry.size.height  // モーダルの初期位置を設定
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
    
    private func check(index: Int) {
        todos[index].isDone.toggle()
        try? context.save()
    }
    
}


#Preview {
    ContentView()
}
