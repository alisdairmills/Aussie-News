//
//  NewsData.swift
//  Feel Good News
//
//  Created by Alexander Thompson on 5/3/21.
//

import Foundation

struct Articles: Decodable {
    
    let data: [Article]

}
// data wont work. change Article to Data? go back over old newsapi code

struct Article: Decodable {
    let author: String?
    let title: String?
    let description: String?
    let url: String?
    let image: String?
    let published_at: String?
    let source: String?
   
    
}



