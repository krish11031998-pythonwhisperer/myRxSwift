//
//  WeatherAPI.swift
//  RxSwiftApp
//
//  Created by Krishna Venkatramani on 30/10/2022.
//

import Foundation
import RxCocoa

fileprivate extension String {
    static let apiKey: String = "7b509e5e1d1e7ff010a0476dae3589ad"
}

enum WeatherAPI {
    case test(q: String)
    case weater(q: String)
}

extension WeatherAPI: Endpoint {
    
    typealias DataModel = WeatherSearchModel
    
    var scheme: String { "https" }
    
    var url: String { "https://api.openweathermap.org" }
    
    var path: String {
        switch self {
        case .test(_), .weater(_):
            return "/data/2.5/weather"
        }
    }
    
    var method: String {
        switch self {
        case .weater(_), .test(_):
            return "GET"
        }
    }
    
    var params: [URLQueryItem] {
        var query: [URLQueryItem]
        switch self {
        case .test(let q):
            query = [.init(name: "q", value: q),
                     .init(name: "callback", value: "test")]
        case .weater(let q):
            query = [.init(name: "q", value: q)]
        }
        query.append(.init(name: "appid", value: .apiKey))
        return query
    }
    
}
