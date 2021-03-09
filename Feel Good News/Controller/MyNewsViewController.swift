//
//  MyNewsViewController.swift
//  Feel Good News
//
//  Created by Alexander Thompson on 12/2/21.
//

import UIKit

struct Articles: Decodable {
    
    let status: String?
    let totalResults: Int?
    let articles: [Article]
 
}

struct Article: Decodable {
    let author: String?
    let title: String?
    let description: String?
    let url: String?

}

class MyNewsViewController: UIViewController {
    
    @IBOutlet weak var label: UILabel!
    
    
    
    let initialUrlString = "https://newsapi.org/v2/"
        let topHeadlineUS = "top-headlines?country=us"
    
    var articles: Articles?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        parseData()
        label.text = articles?.status
        print(articles?.totalResults)
        }
   
    //this finally works. relocate it back to models. find a way to have Articles transfer to Articles/
    func parseData()  {
           let urlString = "\(initialUrlString)\(topHeadlineUS)&apikey=\(HiddenContent().APIKey)"
           if let url = URL(string: urlString) {
            let session = URLSession.shared
               let task = session.dataTask(with: url) { (data, response, error) in
                
                do {
                   
                guard let data = data else { return }
               
                    let article = try JSONDecoder().decode(Articles.self, from: data)
                    DispatchQueue.main.async {
                        self.articles = article
                        self.label.text = article.articles[0].description
                        print(article.articles[0].title)
                    }
                    
               
                
   
                } catch {
           print(error)
                   }
        
        
               }
            task.resume()
           }
    
    }
}
 
