import SwiftUI

@main
struct SunburnOverlayApp: App {
    @StateObject private var menuManager = FloatingMenuManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(menuManager)
                .onAppear {
                    // Cargar el index.html desde el bundle principal
                    if let htmlPath = Bundle.main.path(forResource: "index", ofType: "html") {
                        let url = URL(fileURLWithPath: htmlPath)
                        menuManager.showOverlay(content: AnyView(FloatingMenuView(url: url)))
                    } else if let assetPath = Bundle.main.url(forResource: "index", withExtension: "html") {
                        menuManager.showOverlay(content: AnyView(FloatingMenuView(url: assetPath)))
                    }
                }
        }
    }
}

struct ContentView: View {
    @EnvironmentObject var menuManager: FloatingMenuManager
    
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            VStack(spacing: 20) {
                Text("SUNBURN Overlay (iOS)")
                    .font(.title)
                    .foregroundColor(.white)
                
                Button(action: {
                    menuManager.toggleVisibility()
                }) {
                    Text("Toggle Menu")
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
                
                Text("Instrucciones:")
                    .foregroundColor(.gray)
                Text("- Sideload con AltStore o Sideloadly")
                    .foregroundColor(.gray)
                    .font(.caption)
            }
        }
    }
}

// Vista flotante y arrastrable
struct FloatingMenuView: View {
    let url: URL
    @State private var offset = CGSize.zero
    
    var body: some View {
        VStack {
            // Drag handle superior
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.white.opacity(0.3))
                .frame(width: 40, height: 6)
                .padding(.top, 10)
            
            WebMenuView(url: url)
                .frame(width: 380, height: 600)
                .cornerRadius(20)
                .shadow(radius: 20)
        }
        .offset(offset)
        .gesture(
            DragGesture()
                .onChanged { gesture in
                    self.offset = gesture.translation
                }
                .onEnded { _ in }
        )
    }
}
