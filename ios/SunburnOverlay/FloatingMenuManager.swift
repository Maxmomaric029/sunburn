import SwiftUI
import UIKit

class FloatingMenuManager: ObservableObject {
    var overlayWindow: UIWindow?
    
    func showOverlay(content: AnyView) {
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        guard let scene = windowScene else { return }
        
        // Crear una ventana secundaria de alto nivel
        let newWindow = UIWindow(windowScene: scene)
        newWindow.windowLevel = .alert + 1
        newWindow.backgroundColor = .clear
        
        let rootController = UIHostingController(rootView: content)
        rootController.view.backgroundColor = .clear
        
        newWindow.rootViewController = rootController
        newWindow.isUserInteractionEnabled = true
        newWindow.isHidden = false
        
        self.overlayWindow = newWindow
    }
    
    func toggleVisibility() {
        overlayWindow?.isHidden.toggle()
    }
}
