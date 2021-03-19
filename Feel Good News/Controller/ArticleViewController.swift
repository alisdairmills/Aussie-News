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
    var article: Article?
    var savedViewController = SavedViewController()
    
   
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveItem))
        
        if let safeURL = articleURL {
        if let url = URL(string: safeURL) {
        webView.load(URLRequest(url: url))
            print(article)
           
        }
    }
    }

    @objc func saveItem() {
        savedViewController.appendArticles(article: article!)
        }
    }

