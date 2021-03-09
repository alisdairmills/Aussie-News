//
//  NewsManager.swift
//  Feel Good News
//
//  Created by Alexander Thompson on 4/3/21.
//

import Foundation

protocol NewsManagerDelegate {
    func updateNews(_ newsManager: NewsManager, news: NewsModel)
}

struct NewsManager {
    
    var delegate: NewsManagerDelegate?
    
    let initialUrlString = "https://newsapi.org/v2/"
    let topHeadlineUS = "top-headlines?country=us"
    
   
    
    func parseData()  {
        let urlString = "\(initialUrlString)\(topHeadlineUS)&apikey=\(HiddenContent().APIKey)"
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
           let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    //todo - create a proper error handling func
                    print(error!)
                    return
                }
                if let safeData = data {
                    if let safeNews = self.parse(safeData) {
                        self.delegate?.updateNews(self, news: safeNews)
        
                    }
                 
                }
            }
            
            task.resume()
        }
        
    }
    
     func parse(_ newsData: Data) -> NewsModel? {
        let decoder = JSONDecoder()
        
        do {
            let newsArticle = try decoder.decode(NewsData.self, from: newsData)
            let author = newsArticle.articles[0].author
            let title = newsArticle.articles[0].title
            let description = newsArticle.articles[0].description
            let url = newsArticle.articles[0].url
            let count = newsArticle.articles.count
            let news = NewsModel(newsAuthor: author, newsTitle: title, newsDescription: description, newsURl: url)
            return news
            
        } catch {
                return nil
            }
        
    }
}




