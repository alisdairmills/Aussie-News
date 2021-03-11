//
//  NewsData.swift
//  Feel Good News
//
//  Created by Alexander Thompson on 5/3/21.
//

import Foundation

struct Articles: Decodable {
    
    let status: String?
    let totalResults: Int?
    let articles: [Article]
 
 
}

struct Article: Decodable {
    let author: String?
    let title: String?
    let description: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: String?
    let source: Source?
    let content: String?
    
}

struct Source: Decodable {
    let name: String
}

