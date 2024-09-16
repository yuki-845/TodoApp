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
            Live2DView()
                .shadow(color: Color.red, radius: 0, x: -7, y: 0)
                .frame(width: geometry.size.width, height: geometry.size.height)
                .position(x: geometry.size.width / 2, y: geometry.size.height / 2.2)
            Button {
                kyara = "Haru"
            } label: {
                Text("はるよこい")
                
            }
        }
    }
}

#Preview {
    CharacterSelectView()
}
