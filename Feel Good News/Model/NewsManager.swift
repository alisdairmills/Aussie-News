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
    let apiKey = "apikey=a1c9799d78c040df82b183e5ccae527f"
    let country = "&country=au"
    var search = ""
    let pageSize = "&pagesize=100"
    let language = "&language=en"
    
    
    func parseData(option: String)  {
        var urlString = ""
        if option == "Search" {
            urlString = "\(searchURLString)\(apiKey)\(language)\(search)+australia"
        } else if option == "General" {
            urlString = "\(generalURLString)\(apiKey)\(country)\(pageSize)&category=\(category)"
        }
        
        if let url = URL(string: urlString) {
            let session = URLSession.shared
            let task = session.dataTask(with: url) { (data, response, error) in
                
                do {
                    
                    guard let data = data else { return }
                    
                    let article = try JSONDecoder().decode(Articles.self, from: data)
                    self.delegate?.updateNews(self, news: article)
                    
                    
                } catch {
                    print(error.localizedDescription)
                }
                
            }
            task.resume()
            
        }
        
    }
    
    func dateFormatter(date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let date = dateFormatter.date(from: date)
        dateFormatter.dateFormat = "MMM d, yyyy"
        return dateFormatter.string(from: date!)
    }
}



