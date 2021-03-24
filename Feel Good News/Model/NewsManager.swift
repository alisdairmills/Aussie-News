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
    
    let generalURLString =  "https://newsapi.org/v2/top-headlines?"
    let searchURLString = "https://newsapi.org/v2/everything?"
    let categories = ["general", "business", "entertainment", "health", "science", "sports", "technology"]
    var category = "general"
    let apiKey = "apikey=\(HiddenContent().APIKey)"
    let country = "&country=au"
    var search = ""
    let pageSize = "&pagesize=100"

    
    func parseData(option: String)  {
     var urlString = "\(generalURLString)\(apiKey)\(country)\(pageSize)"
      if option == "Search" {
            urlString = urlString + search
      } else if option == "General" {
        urlString = urlString + "&category=\(category)"
      }
        
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


}



