//
//  ArticleViewController.swift
//  Feel Good News
//
//  Created by Alexander Thompson on 12/2/21.
//

import UIKit
import WebKit


class ArticleViewController: UIViewController, WKNavigationDelegate {
  
    var webView: WKWebView!
    var articleURL: String?
    var articleTitle: String?
    var articleName: String?
    var articleDate: String?
    var article: Article?
    var savedArticles = [Article]()
    var savedImageName = "bookmark"
    var date: String?
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        barButtons(bookmark: "bookmark")
        
        // This loop prevents articles from being saved twice by searching the array for matching URLs.
        for i in GlobalArray.savedArrayGlobal {
            if i.url == articleURL {
                savedImageName = "bookmark.fill"
                barButtons(bookmark: "bookmark.fill")
            }
        }
        let userDefaults = UserDefaults.standard
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
    
    //alert for when user saved or removes article
    func savedAlert(note: String) {
        let ac = UIAlertController(title: note, message: "", preferredStyle: .alert)
        self.present(ac, animated: true) {
            Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false) { _ in
                self.dismiss(animated: true, completion: nil)
    }
        }
    }
    
    @objc func save() {
        
        if savedImageName == "bookmark" {
            savedImageName = "bookmark.fill"
            barButtons(bookmark: "bookmark.fill")
            GlobalArray.savedArrayGlobal.insert(article!, at: 0)
            GlobalArray.dateArrayGlobal.insert(date ?? "", at: 0)
           savedAlert(note: "Article Saved")
                }
            
         else if savedImageName == "bookmark.fill" {
            savedImageName = "bookmark"
            barButtons(bookmark: "bookmark")
            GlobalArray.savedArrayGlobal.removeFirst()
            GlobalArray.dateArrayGlobal.removeFirst()
            savedAlert(note: "Article Removed")
        }
      
      
}

}
