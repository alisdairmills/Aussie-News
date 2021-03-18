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
    

    let initialUrlString = "https://api.mediastack.com/v1/news?access_key="
    let apiKey = HiddenContent().APIKey
    let categories = ["general", "business", "entertainment", "health", "science", "sports", "technology"]
    var category = "general"
    var delegate: NewsManagerDelegate?
    
    

    func parseData()  {

        let urlString = "\(initialUrlString)\(HiddenContent().APIKey)&categories=\(category)&countries=au,us&languages=en&sort=popularity&limit=100"
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



