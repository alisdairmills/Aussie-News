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
    var savedImageName = "bookmark"
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        barButtons(bookmark: "bookmark")
        
        // This loop prevents articles from being saved twice by searching the array for matching URLs.
        for i in GlobalArray.SavedArrayGlobal {
            if i.url == articleURL {
                savedImageName = "bookmark.fill"
                barButtons(bookmark: "bookmark.fill")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
               
        if let safeURL = articleURL {
            if let url = URL(string: safeURL) {
                webView.load(URLRequest(url: url))
                navigationItem.title = articleName
                
            }
        }
    }
        func barButtons(bookmark: String) {
            
            let shareButton = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .plain, target: self, action: #selector(share))
            
            let saveButton = UIBarButtonItem(image: UIImage(systemName: bookmark), style: .plain, target: self, action: #selector(save))
            navigationItem.rightBarButtonItems = [shareButton, saveButton]
        }
    
    
    @objc func share() {
        let items: [Any] = ["\(articleTitle!)", URL(string: articleURL!) as Any]
    
        let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
        ac.popoverPresentationController?.sourceView = self.webView
        present(ac, animated: true)
    }
    
    // when returning to same link how do I keep saveimagename consistant? loop to search for urls. if no mathing then save
    @objc func save() {
        
        if savedImageName == "bookmark" {
            savedImageName = "bookmark.fill"
            barButtons(bookmark: "bookmark.fill")
            GlobalArray.SavedArrayGlobal.insert(article!, at: 0)
        } else if savedImageName == "bookmark.fill" {
            savedImageName = "bookmark"
            barButtons(bookmark: "bookmark")
            GlobalArray.SavedArrayGlobal.removeFirst()
        }
      
      
}

}
