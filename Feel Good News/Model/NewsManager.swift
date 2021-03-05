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
    
    func getNews(with urlString: String) {
        
        if let url = URL(string: urlString) {
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print(error)
                    return
                }
                if let data = data {
                    let newsEnvelope = try? JSONDecoder().decode(NewsEnvelope.self, from: data)
                   //find a way to decode newsenvelope here in a way I understand. write out a step by step JSon process for what needs to happen
                }
            }
        }
        
    }
    
    
    
    
    
    
    //    func getNews(completion: @escaping ([NewsModel]?) -> Void) {
//        let urlString = "\(initialUrlString)\(topHeadlineUS)&apikey=\(HiddenContent().APIKey)"
//        guard let url = URL(string: urlString) else {return}
//
//        URLSession.shared.dataTask(with: url) { (data, reponse, error) in
//            guard error == nil, let data = data else {
//                print(error!)
//                return
//            }
//
//            let newsEnvelope = try? JSONDecoder().decode(NewsEnvelope.self, from: data)
//            newsEnvelope == nil ? completion(nil) : completion(newsEnvelope?.articles)
//            }
//        .resume()
//        }
        
    
    }





