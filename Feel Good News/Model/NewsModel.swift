//
//  NewsModel.swift
//  Feel Good News
//
//  Created by Alexander Thompson on 5/3/21.
//

import Foundation

struct NewsModel: Decodable {
    let author: String?
    let title: String?
    let description: String?
    let url: String?
    let urlToImage: String?
  
}

struct NewsEnvelope: Decodable {
    
    let status: String
    let totalResults: Int
    let articles: [NewsModel]
    
}
