//
//  ArticleViewController.swift
//  Feel Good News
//
//  Created by Alexander Thompson on 12/2/21.
//

import UIKit
import WebKit

class ArticleViewController: UIViewController, WKNavigationDelegate {
    //bind webview bounds so that it doesnt go under nav and tab controllers
    var webView: WKWebView!
    
    var articleURL: String?
    
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let safeURL = articleURL {
        if let url = URL(string: safeURL) {
        webView.load(URLRequest(url: url))
        }
    }
    }

}
