//
//  NewsModel.swift
//  RxSwiftApp
//
//  Created by Krishna Venkatramani on 26/10/2022.
//

import Foundation
import RxSwift

struct NewsResultModel: Codable {
    let status: String
    let totalResults: Int
    let articles: [NewsModel]
}

struct NewsModel: Codable {
    let author: String?
    let title: String?
    let description: String?
    let url: String?
    let urlToImage: String?
    let content: String?
    let publishedAt: String?
}
