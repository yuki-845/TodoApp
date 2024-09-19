import UIKit
import SwiftUI
import Live2DMetal



struct HiragiMikuroView: UIViewControllerRepresentable {
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
