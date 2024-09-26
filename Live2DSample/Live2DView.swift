import UIKit
import SwiftUI
import Live2DMetal



struct HiragiMirokuView: UIViewControllerRepresentable {
    typealias UIViewControllerType = Live2DViewController
    
//    var kyara: String
    func makeUIViewController(context: Context) -> Live2DViewController {
        
        Live2DViewController(resourcesPath: "res/", modelName: "HiragiMiroku")
        
    }

    func updateUIViewController(
        _ uiViewController: Live2DViewController,
        context: Context
    ) {
        
    }
    
}

struct HiyoriView: UIViewControllerRepresentable {
    typealias UIViewControllerType = Live2DViewController
    @Binding var isActive: Bool
    func makeUIViewController(context: Context) -> Live2DViewController {
        
        Live2DViewController(resourcesPath: "res/", modelName: "Hiyori")
    }

    func updateUIViewController(
        _ uiViewController: Live2DViewController,
        context: Context
    ) {
//        uiViewController.isActive = isActive
////        if isActive {
////                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { // 2秒後にfalseに
////                        self.isActive = false
////                    }
////                }
    }
    
}

