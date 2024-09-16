import UIKit
import SwiftUI
import Live2DMetal


var kyara = "Hiyori"
struct Live2DView: UIViewControllerRepresentable {
    typealias UIViewControllerType = Live2DViewController
    
    func makeUIViewController(context: Context) -> Live2DViewController {
        if(kyara == "Hiyori") {
            Live2DViewController(resourcesPath: "res/", modelName: "Hiyori")
        }else {
            Live2DViewController(resourcesPath: "res/", modelName: "Haru")
        }
        
        
    }

    func updateUIViewController(
        _ uiViewController: Live2DViewController,
        context: Context
    ) {}
}
