//
//  ArticleModel.swift
//  Task
//
//  Created by Khaled on 27/12/2021.
//

import Foundation

// MARK: - Welcome
struct ArticleRoot: Codable {
    let status: String?
    let totalResults: Int?
    let articles: [Article]?
}

// MARK: - Article
struct Article: Codable {
    let source: Source?
    let author: String?
    let title: String?
    let articleDescription: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: String?
    let content: String?

    enum CodingKeys: String, CodingKey {
        case source, author, title
        case articleDescription = "description"
        case url, urlToImage, publishedAt, content
    }
    
    init(_ CoreDataModel : ArticleCD) {
        self.title = CoreDataModel.name
        self.url = CoreDataModel.url
        self.urlToImage = CoreDataModel.imgURL
        self.content = CoreDataModel.content
        self.author = CoreDataModel.author
        self.publishedAt = nil
        self.source = nil
        self.articleDescription = nil
    }
}

// MARK: - Source
struct Source: Codable {
    let id: String?
    let name: String?
}
