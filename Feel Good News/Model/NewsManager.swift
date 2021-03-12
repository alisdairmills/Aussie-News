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
    let search = "&keywords=australia"
    var delegate: NewsManagerDelegate?

    func parseData()  {

        let urlString = "\(initialUrlString)\(HiddenContent().APIKey)&sources=en"
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

    func getImage(from string: String) -> UIImage? {
        guard let url = URL(string: string) else { return nil }
        var URLImage: UIImage?
        do {
            let data = try Data(contentsOf: url)
            URLImage = UIImage(data: data)
        } catch {
            print("error")
        }

        return URLImage
    }

}



