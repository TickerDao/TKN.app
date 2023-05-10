//
//  UIWebView.swift
//  TKN
//
//  Created by Oak on 5/10/23.
//  Copyright © 2023 Superadditive. All rights reserved.
//

import Foundation
import UIKit
import WebKit

class UIWebView: UIView, WKNavigationDelegate {
    var url: URL
    var webView: WKWebView?
    
    init(url: URL, tag: Int) {
        self.url = url
        super.init(frame: .zero) // Use .zero since the frame will be set later.
        
        let webView = WKWebView(frame: bounds)
        webView.navigationDelegate = self
        webView.scrollView.refreshControl = UIRefreshControl()
        webView.scrollView.refreshControl?.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        webView.load(URLRequest(url: url))
        self.webView = webView
        webView.backgroundColor = Constants.backgroundColor
        let swipeBackRecognizer = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(goBack(_:)))
        swipeBackRecognizer.edges = .left
        webView.addGestureRecognizer(swipeBackRecognizer)
        addSubview(webView)
        
        // Set the constraints for the webView.
        webView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: topAnchor),
            webView.bottomAnchor.constraint(equalTo: bottomAnchor),
            webView.leadingAnchor.constraint(equalTo: leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func handleWebViewReload(notification: NSNotification) {
        if let userInfo = notification.userInfo, let selectedTab = userInfo["selectedTab"] as? Int, selectedTab == tag {
            print("NSNotification \(selectedTab)")
            switch selectedTab {
            case 0:
                if let url = URL(string: Constants.tab0) {
                    webView?.load(URLRequest(url: url))
                }
            case 1:
                if let url = URL(string: Constants.tab1) {
                    webView?.load(URLRequest(url: url))
                }
            case 2:
                if let url = URL(string: Constants.tab2) {
                    webView?.load(URLRequest(url: url))
                }
            case 3:
                if let url = URL(string: Constants.tab3) {
                    webView?.load(URLRequest(url: url))
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
        if recognizer.state == .recognized, webView?.canGoBack ?? false {
            webView?.goBack()
        }
    }
    
    @objc func refresh(_ refreshControl: UIRefreshControl) {
        webView?.reload()
        refreshControl.endRefreshing()
    }
}
