import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    let url: URL
    let tag: Int

    init(url: URL, tag: Int) {
        self.url = url
        self.tag = tag
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        webView.scrollView.refreshControl = UIRefreshControl()
        webView.scrollView.refreshControl?.addTarget(context.coordinator, action: #selector(Coordinator.refresh), for: .valueChanged)
        webView.load(URLRequest(url: url))
        context.coordinator.webView = webView


        let swipeBackRecognizer = UIScreenEdgePanGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.goBack))
        swipeBackRecognizer.edges = .left
        webView.addGestureRecognizer(swipeBackRecognizer)

        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {

    }

    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: WebView
        weak var webView: WKWebView?

        init(_ parent: WebView) {
            self.parent = parent
            super.init()
            NotificationCenter.default.addObserver(self, selector: #selector(handleWebViewReload(notification:)), name: NSNotification.Name("com.user.webView.reload"), object: nil)
        }

        @objc func handleWebViewReload(notification: NSNotification) {
            if let userInfo = notification.userInfo, let selectedTab = userInfo["selectedTab"] as? Int, selectedTab == parent.tag {
                print("NSNotification \(selectedTab)")
                switch selectedTab {
                case 0:
                    if let url = URL(string: Constants.tab0), let webView = webView {
                        webView.load(URLRequest(url: url))
                    }
                case 1:
                    if let url = URL(string: Constants.tab1), let webView = webView {
                        webView.load(URLRequest(url: url))
                    }
                case 2:
                    if let url = URL(string: Constants.tab2), let webView = webView {
                        webView.load(URLRequest(url: url))
                    }
                case 3:
                    if let url = URL(string: Constants.tab3), let webView = webView {
                        webView.load(URLRequest(url: url))
                    }
                default:
                    print("Unsupported tab")
                }
            }
        }
        
        func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            if let url = navigationAction.request.url, shouldHandleInSafari(url) {
                decisionHandler(.cancel)
                UIApplication.shared.open(url)
            } else {
                decisionHandler(.allow)
            }
        }
        
        private func shouldHandleInSafari(_ url: URL) -> Bool {
            // Modify this to open links in the app, instead of in safari
            print("browser url \(url)")
            let urlString = url.absoluteString
            if (urlString.contains(Constants.hostUrl)) {
                return false
            } else {
                return true
            }
        }

        @objc func goBack(_ recognizer: UIScreenEdgePanGestureRecognizer) {
            if let webView = recognizer.view as? WKWebView, recognizer.state == .recognized, webView.canGoBack {
                webView.goBack()
            }
        }

        @objc func refresh(_ refreshControl: UIRefreshControl) {
            if let webView = refreshControl.superview?.superview as? WKWebView {
                webView.reload()
                refreshControl.endRefreshing()
            }
        }
    }
}
