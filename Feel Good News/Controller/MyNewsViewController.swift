//
//  MyNewsViewController.swift
//  Feel Good News
//
//  Created by Alexander Thompson on 12/2/21.
//

import UIKit

class MyNewsViewController: UIViewController {
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var buttonText: UIButton!
    
    var newsManager = NewsManager()
    var articles: [Article]?
    var number: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newsManager.delegate = self
        newsManager.parseData()
        
        }
   
    @IBAction func buttonPressed(_ sender: UIButton) {
        label.text = String(articles!.count)
        
        
    }
}

//MARK: - News Manager Delegate

extension MyNewsViewController: NewsManagerDelegate {
    func updateNews(_ newsManager: NewsManager, news: Articles) {
        DispatchQueue.main.async {
            //self.label.text = String(news.articles.count)
            self.articles = news.articles
            self.number = news.articles.count
            
           
        }
        
    }
    
    
    
}

 
