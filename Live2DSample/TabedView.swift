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
        UITabBar.appearance().unselectedItemTintColor = .green.withAlphaComponent(1)
        UITabBar.appearance().scrollEdgeAppearance = appearance
        UITabBar.appearance().standardAppearance = appearance
    }
    
    var body: some View {
       
        TabView {
            ContentView()
                .tabItem {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.white)
                    Text("Todo")
                }
            
            CharacterSelectView()
                .tabItem {
                    Image(uiImage: resizeImage(named: "SHES", width: 60)) // ここでリサイズしたUIImageを使用
                                            .renderingMode(.template) // テンプレートモードで色を変更可能に
                                            .foregroundColor(.green)
                    Text("キャラ選択")
                }
        }
        .accentColor(.white)
    }
    func resizeImage(named: String, width: CGFloat) -> UIImage {
            guard let image = UIImage(named: named) else { return UIImage() }
            
            let aspectRatio = image.size.height / image.size.width
            let size = CGSize(width: width, height: width * aspectRatio)
            
            UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
            image.draw(in: CGRect(origin: .zero, size: size))
            let resizedImage = UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
            UIGraphicsEndImageContext()
            
            return resizedImage
        }
}



#Preview {
    TabeView()
}
