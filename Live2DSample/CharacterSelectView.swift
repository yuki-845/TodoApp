//
//  CharcterSelectView.swift
//  Live2DSample
//
//  Created by 平井悠貴 on 2024/09/16.
//

import SwiftUI

struct CharacterSelectView: View {
    @State private var kyara = "Hiyori"  // キャラクター名を管理するState変数
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ZStack {
                                // 画像にマスクを適用
                                Image("RUKA 1")
                                   
                                    
                                    
                                    .offset(x: geometry.size.width * 0.13, y: geometry.size.height * 1.1) // 位置をマスクと同じに調整
                                    .mask(
                                        Rectangle()
                                            .frame(width: 2000, height: geometry.size.height / 4.2)
                                            .rotationEffect(.degrees(-47)) // -47度回転
                                            .offset(x: 50, y: -geometry.size.height * 0.25) // マスクの位置調整
                                    )
                                
                                // 透明な四角形を同じ位置に配置
                                Rectangle()
                                    .frame(width: 2000, height: geometry.size.height / 4.2)
                                    .rotationEffect(.degrees(-47)) // -47度回転
                                    .offset(x: 50, y: -geometry.size.height * 0.25) // 位置をマスクと同じに調整
                                    .foregroundColor(.red) // 四角形の色
                                    .opacity(0.6) // 透明度
                            }
                            .frame(width: geometry.size.width, height: geometry.size.height) // ZStackのサイズ調整
                
                if(kyara == "Hiyori") {
                    HiyoriView()
                        .shadow(color: Color.red, radius: 0, x: -7, y: 0)
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .position(x: geometry.size.width / 2, y: geometry.size.height / 2.2)
                    
                }else {
                    HaruView()
                        .shadow(color: Color.red, radius: 0, x: -7, y: 0)
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .position(x: geometry.size.width / 2, y: geometry.size.height / 2.2)
                    
                }
            }
            ZStack {
                Image("RUKAPASS")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .offset(x: -7, y: 7)
                Image("RUKA2")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                
            }
            .frame(width: geometry.size.width / 2)
            .position(x: geometry.size.width / 2, y: geometry.size.height / 1.5)
            
            
            
        }
    }
}

#Preview {
    CharacterSelectView()
}
