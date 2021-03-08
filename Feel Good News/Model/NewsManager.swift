//
//  NewsManager.swift
//  Feel Good News
//
//  Created by Alexander Thompson on 4/3/21.
//

import Foundation

struct NewsManager {

    let imageCache = NSCache<NSString, NSData>()
    
    static let shared = NewsManager()
    private init() {}
    
    let initialUrlString = "https://newsapi.org/v2/"
    let topHeadlineUS = "top-headlines?country=us"
    
    func getNews(completion: @escaping ([NewsModel]?) -> Void)  {
        let urlString = "\(initialUrlString)\(topHeadlineUS)&apikey=\(HiddenContent().APIKey)"
        
        if let url = URL(string: urlString) {
           let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print(error!)
                    return
                }
                if let safeData = data {
                    let newsEnvelope = try? JSONDecoder().decode(NewsEnvelope.self, from: safeData)
                    newsEnvelope == nil ? completion(nil) : completion(newsEnvelope!.articles)
                }
            }
            task.resume()
        }
        
    }
    
    func getImage(urlString: String, completion: @escaping (Data?) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
    }
        if let cachedImage = imageCache.object(forKey: NSString(string: urlString)) {
            completion(cachedImage as Data)
        } else {
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                guard error == nil, let data = data else {
                    completion(nil)
                    return
                }
                self.imageCache.setObject(data as NSData, forKey: NSString(string: urlString))
                completion(data)
            } .resume()
        }
    }
}




