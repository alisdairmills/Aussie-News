//
//  NewsManager.swift
//  Feel Good News
//
//  Created by Alexander Thompson on 4/3/21.
//

import Foundation
import UIKit

protocol NewsManagerDelegate {
    func updateNews(_ newsManager: NewsManager, news: Articles)
    
}

struct NewsManager {
    var delegate: NewsManagerDelegate?
    
    let initialUrlString =  "https://newsapi.org/v2/top-headlines?category="
    let categories = ["general", "business", "entertainment", "health", "science", "sports", "technology"]
    var category = "general"
    let apiKey = "&apikey=\(HiddenContent().APIKey)"
 var country = "&country=au"
    var search: String = ""
    
    
    func parseData()  {

        let urlString = "\(initialUrlString)\(category)\(apiKey)\(country)&pagesize=100"
        if let url = URL(string: urlString) {
            let session = URLSession.shared
            let task = session.dataTask(with: url) { (data, response, error) in

                do {

                    guard let data = data else { return }
                   
                    let article = try JSONDecoder().decode(Articles.self, from: data)
                    self.delegate?.updateNews(self, news: article)
                   
                
                } catch {
                    print(error)
                }

            }
            task.resume()
            
        }

    }

    // for collectionView categories on home page. Each button pressed passes to indexpath to the func which is then used in the newsmanager catwegories array.
   

}



