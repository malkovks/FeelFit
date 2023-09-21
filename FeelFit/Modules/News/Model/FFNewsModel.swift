//
//  TestModel.swift
//  FeelFit
//
//  Created by Константин Малков on 21.09.2023.
//

import UIKit

//struct Root: Codable {
//    let status: String
//    let totalResults: Int
//    let articles: [Articles]
//}
//
//struct Articles: Codable {
//    let source: Source
//    let author: String
//    let title: String
//    let description: String?
//    let url: String?
//    let urlToImage: String?
//    let publishedAt: String
//    let content: String
//}
//
//struct Source: Codable {
//    let id: String
//    let name: String
//}

struct APIResponse: Codable {
    //наследование структуры ниже
    let articles: [Articles]
}
//структура с наследованием API пунктов новостей, которые там имеются
struct Articles: Codable{
    let source: Source
    let title: String
    let description: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: String

}
//отдельная структура тк там идет несколько подпунктов, которые мы не берем
struct Source: Codable{
    let name: String
}

//enum CodingKeys: String, CodingKey {
//    case source, author, title, _description = "description", url, urlToImage, publishedAt, content
//}
