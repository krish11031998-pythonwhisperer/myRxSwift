//
//  NewsAPI.swift
//  RxSwiftApp
//
//  Created by Krishna Venkatramani on 26/10/2022.
//

import Foundation
import UIKit
import RxSwift

fileprivate extension String {
    static let newsAPIKey: String = "21d3605f957b4109842c8ff800f45b36"
}

//MARK: - Endpoints

enum NewsAPIEndpoint {
    case topHeadline(country: String)
}


//MARK: - NewsAPI Endpoint

extension NewsAPIEndpoint: Endpoint {
    
    typealias DataModel = NewsResultModel
    
    var scheme: String { "https" }
    
    var url: String {
        "https://newsapi.org"
    }
    
    var path: String {
        switch self {
        case .topHeadline(_):
            return "/v2/top-headlines"
        }
    }
    
    var method: String {
        switch self {
        case .topHeadline(_):
            return "GET"
        }
    }
    
    var params: [URLQueryItem] {
        var query: [URLQueryItem]
        switch self {
        case .topHeadline(let country):
            query = [.init(name: "country", value: country)]
        }
        query.append(.init(name: "apiKey", value: .newsAPIKey))
        return query
    }

}
