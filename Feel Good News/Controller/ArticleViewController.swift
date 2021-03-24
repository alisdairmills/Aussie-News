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
    var articleTitle: String?
    var articleName: String?
    var article: Article?
    var savedArticles = [Article]()
        
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .plain, target: self, action: #selector(share))
        print(articleURL)
        if let safeURL = articleURL {
            if let url = URL(string: safeURL) {
                webView.load(URLRequest(url: url))
                navigationItem.title = articleName
            }
        }
    }
    
    @objc func share() {
        let items: [Any] = ["\(articleTitle!)", URL(string: articleURL!) as Any]
        
        let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
        ac.popoverPresentationController?.sourceView = self.webView
        present(ac, animated: true)
    }
}

