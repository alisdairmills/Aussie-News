//
//  NewsManager.swift
//  Feel Good News
//
//  Created by Alexander Thompson on 4/3/21.
//

import Foundation

protocol NewsManagerDelegate {
    func updateNews(_ newsManager: NewsManager, news: Articles)
}

struct NewsManager {

    let initialUrlString = "https://newsapi.org/v2/"
    let topHeadlineUS = "top-headlines?country=us"
    var delegate: NewsManagerDelegate?
    
    func parseData()  {
        
        let urlString = "\(initialUrlString)\(topHeadlineUS)&apikey=\(HiddenContent().APIKey)"
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



















//protocol NewsManagerDelegate {
//    func updateNews(_ newsManager: NewsManager, news: Articles)
//}

//struct NewsManager {
//
//    var delegate: NewsManagerDelegate?
//
//    let initialUrlString = "https://newsapi.org/v2/"
//    let topHeadlineUS = "top-headlines?country=us"
//
//
//
//    func parseData()  {
//        let urlString = "\(initialUrlString)\(topHeadlineUS)&apikey=\(HiddenContent().APIKey)"
//        if let url = URL(string: urlString) {
//
//            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
//                if error != nil {
//                    //todo - create a proper error handling func
//                    print(error!)
//                    return
//                }
//                let decoder = JSONDecoder()
//                if let safeData = data {
//                    if let safeNews = self.parse(safeData) {
//                        self.delegate?.updateNews(self, news: safeNews)
//
//                    }
//
//                }
//            }
//            task.resume()
//        }
//
//    }
//
//     func parse(_ newsData: Data) -> Articles? {
//        let decoder = JSONDecoder()
//
//        do {
//            let newsArticle = try decoder.decode(Articles.self, from: newsData)
//            let status = newsArticle.status
//            let total = newsArticle.totalResults
//            let articles = [Article]()
//
//
//
////            let author = newsArticle.articles[0].author
////            let title = newsArticle.articles[0].title
////            let description = newsArticle.articles[0].description
////            let url = newsArticle.articles[0].url
//
//            let news = Articles(status: status, totalResults: total, articles: articles)
//            return news
//
//        } catch {
//                return nil
//            }
//
//    }
//}
//
//
//
//
