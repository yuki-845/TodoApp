import UIKit
import SwiftUI
import Live2DMetal



struct HiyoriView: UIViewControllerRepresentable {
    typealias UIViewControllerType = Live2DViewController
//    var kyara: String
    func makeUIViewController(context: Context) -> Live2DViewController {
        
        Live2DViewController(resourcesPath: "res/", modelName: "Hiyori")
        
    }

    func updateUIViewController(
        _ uiViewController: Live2DViewController,
        context: Context
    ) {
        
    }
}
struct HaruView: UIViewControllerRepresentable {
    typealias UIViewControllerType = Live2DViewController
//    var kyara: String
    func makeUIViewController(context: Context) -> Live2DViewController {
        
        Live2DViewController(resourcesPath: "res/", modelName: "Haru")
        
    }

    func updateUIViewController(
        _ uiViewController: Live2DViewController,
        context: Context
    ) {
        
    }
}
