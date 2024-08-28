//
//  ViewController.swift
//  sample-hook-page-transitions-with-wkwebview
//

import UIKit
import WebKit

class ViewController: UIViewController {

    @IBOutlet weak var webview: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.webview.navigationDelegate = self
        self.webview.uiDelegate = self
        
        // 初期ページ読み込み
        let url: URL? = Bundle.main.url(forResource: "sample", withExtension: "html")
        let request = URLRequest(url: url!)
        self.webview.load(request)
    }
}

extension ViewController: WKUIDelegate {
    func webView(_ webView: WKWebView,
                 createWebViewWith configuration: WKWebViewConfiguration,
                 for navigationAction: WKNavigationAction,
                 windowFeatures: WKWindowFeatures) -> WKWebView? {
        
        guard let requestUrl = navigationAction.request.url else {
            return nil
        }
        if requestUrl.absoluteString.hasPrefix("https://www.apple.com/") {
            // 標準ブラウザアプリ（Safari等）で開く
            UIApplication.shared.open(requestUrl)
            
            // WebViewでの遷移をキャンセル
            return nil
        } else {
            let newWebView = WKWebView(frame: webView.frame,
                                       configuration: configuration)
            newWebView.load(navigationAction.request)
            newWebView.uiDelegate = self
            webView.superview?.addSubview(newWebView)
            return newWebView
        }
    }
}

extension ViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView,
                 decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        guard let requestUrl = navigationAction.request.url else {
            decisionHandler(.allow)
            return
        }
        if requestUrl.absoluteString.hasPrefix("https://www.apple.com/") {
            // WebViewでの遷移をキャンセルして
            decisionHandler(.cancel)
            // 標準ブラウザアプリ（Safari等）で開く
            UIApplication.shared.open(requestUrl)
        } else {
            decisionHandler(.allow)
        }
    }
}

