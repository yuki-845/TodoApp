//
//  SwiftUIView.swift
//  Live2DSample
//
//  Created by 平井悠貴 on 2024/09/16.
//

import SwiftUI
import SwiftData
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
                    .contentShape(Rectangle())  // VStack全体をジェスチャー領域に指定
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
