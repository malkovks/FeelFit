//
//  TestModel.swift
//  FeelFit
//
//  Created by Константин Малков on 21.09.2023.
//

import UIKit


struct APIResponse: Codable {
    let articles: [Articles]
}

struct Articles: Codable, Hashable {
    static func == (lhs: Articles, rhs: Articles) -> Bool {
        return lhs.title == rhs.title && lhs.source.name == rhs.source.name && lhs.publishedAt == rhs.publishedAt
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(title)
        hasher.combine(source.name)
        hasher.combine(publishedAt)
    }
    
    let source: Source
    let title: String
    let description: String?
    let url: String
    let urlToImage: String?
    let publishedAt: String
    let author: String?
    let content: String?
    
    static func convertRealmModel(model: FFNewsModelRealm) -> Articles{
        let value = Articles(source: Source(name: model.newsSourceName), title: model.newsTitle, description: model.description, url: model.newsURL, urlToImage: model.newsImageURL, publishedAt: model.newsPublishedAt ?? "", author: model.newsAuthor, content: model.newsContent)
        return value
    }

}

struct Source: Codable{
    var name: String
}
