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


struct Article: Decodable {
    let author: String?
    let title: String?
    let description: String?
    let category: String?
    let url: String?
    let image: String?
    let published_at: String?
    let source: String?
   
    
}



