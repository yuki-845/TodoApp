//
//  TavView.swift
//  Live2DSample
//
//  Created by 平井悠貴 on 2024/09/16.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            ContentView()
                .tabItem {
                    Image(systemName: "1.circle")
                    Text("First")
                }
            
            CharacterSelectView()
                .tabItem {
                    Image(systemName: "2.circle")
                    Text("Second")
                }
                .badge(5)
            
        }
    }
}

#Preview {
    ContentView()
}
