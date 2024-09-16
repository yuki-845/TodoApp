//
//  TavView.swift
//  Live2DSample
//
//  Created by 平井悠貴 on 2024/09/16.
//

import SwiftUI

struct TabeView: View {
   
            //TabViewの背景色の設定（青色）
    init() {
        let appearance: UITabBarAppearance = UITabBarAppearance()
        appearance.backgroundColor = UIColor(red: 20 / 255, green: 54 / 255, blue: 62 / 255, alpha: 1.0)

        UITabBar.appearance().scrollEdgeAppearance = appearance
        UITabBar.appearance().standardAppearance = appearance
    }
        
    var body: some View {
        TabView {
            ContentView()
                .tabItem {
                    Image(systemName: "1.circle")
                        .foregroundColor(.white)
                    Text("Todo")
                }
            
            CharacterSelectView()
                .tabItem {
                    Image(systemName: "2.circle")
                        .foregroundColor(.white)
                    Text("キャラ選択")
                }
                .badge(5)
            
        }
    }
}

#Preview {
    TabeView()
}
