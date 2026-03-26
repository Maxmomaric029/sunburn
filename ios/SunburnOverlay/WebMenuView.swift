import SwiftUI
import WebKit

struct WebMenuView: UIViewRepresentable {
    let url: URL

    func makeUIView(context: Context) -> WKWebView {
        let config = WKWebViewConfiguration()
        
        // Permite reproducción inline y configuraciones para overlay
        config.allowsInlineMediaPlayback = true
        
        // WebView transparente
        let webView = WKWebView(frame: .zero, configuration: config)
        webView.isOpaque = false
        webView.backgroundColor = .clear
        webView.scrollView.backgroundColor = .clear
        
        // Desactiva el bounce para que parezca un menú nativo
        webView.scrollView.isScrollEnabled = false
        webView.scrollView.bounces = false
        
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        uiView.load(request)
    }
}
