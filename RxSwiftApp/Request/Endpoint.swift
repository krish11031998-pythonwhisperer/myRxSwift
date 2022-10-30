//
//  Endpoint.swift
//  RxSwiftApp
//
//  Created by Krishna Venkatramani on 30/10/2022.
//

import Foundation
import RxSwift

protocol Endpoint {
    associatedtype DataModel: Codable
    
    var scheme: String { get }
    
    var url: String { get }
    
    var params: [URLQueryItem] { get }
    
    var path: String { get }
    
    var method: String { get }
    
    var request: URLRequest? { get }
    
    var executeRequest: Observable<DataModel> { get }
}


extension Endpoint {
    
    var request: URLRequest? {
        guard var uC = URLComponents(string: url) else { return nil }
        uC.scheme = scheme
        uC.path = path
        uC.queryItems = params
        guard let url = uC.url else { return nil }
        return .init(url: url)
    }
    
    var executeRequest: Observable<DataModel> {
        guard let validRequest = request else {
            return Observable.empty()
        }
//        return validRequest.executeRequest()
        return Observable.just(validRequest)
            .flatMap { URLSession.shared.rx.data(request: $0) }
            .compactMap {
                do {
                    let result = try JSONDecoder().decode(DataModel.self, from: $0)
                    return result
                } catch {
                    print("(DEBUG) err : ",error.localizedDescription)
                    return nil
                }
            }
    }
    
}
