//
//  Live2DView 2.swift
//  Live2DSample
//
//  Created by 平井悠貴 on 2024/09/16.
//
import SwiftUI
import Live2DMetalObjC

struct Live2DView: UIViewControllerRepresentable {
    typealias UIViewControllerType = Live2DViewController

    var kyara: String  // キャラクター名を変数として保持
    
    func makeUIViewController(context: Context) -> Live2DViewController {
        // キャラクターに応じてモデルを切り替える
        if kyara == "Hiyori" {
            return Live2DViewController(resourcesPath: "res/", modelName: "Hiyori")
        } else {
            return Live2DViewController(resourcesPath: "res/", modelName: "Haru")
        }
    }

    func updateUIViewController(_ uiViewController: Live2DViewController, context: Context) {
        // 必要に応じて更新処理を記述
    }
}
