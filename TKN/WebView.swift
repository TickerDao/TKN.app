import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    let url: URL
    
    let webViewConfiguration = WKWebViewConfiguration()
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.load(URLRequest(url: url))
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        // Nothing to update.
    }
}
