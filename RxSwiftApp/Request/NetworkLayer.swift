//
//  File.swift
//  RxSwiftApp
//
//  Created by Krishna Venkatramani on 26/10/2022.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

enum NetworkError: String, Error {
    case invalidURL
    case noData
    case decodeError
}

protocol RequestCacheSubscript {
    subscript(urlStr: String) -> Data? { get set }
}

struct RequestCache: RequestCacheSubscript {
    let cache: NSCache<NSString, NSData> = {
        let cache = NSCache<NSString,NSData>()
        cache.countLimit = 100
        return cache
    }()
    
    static var shared: Self = .init()
    
    subscript(urlStr: String) -> Data? {
        get {
            cache.object(forKey: urlStr as NSString) as? Data
        }
        
        set {
            
            if let _ = cache.object(forKey: urlStr as NSString) {
                cache.removeObject(forKey: urlStr as NSString)
            }
            
            guard let validData = newValue as? NSData else { return }
            cache.setObject(validData, forKey: urlStr as NSString)
            
        }
    }
}


extension URLRequest {
    
    func executeRequest<T:Codable>() -> Observable<T> {
        
        return Observable<T>.create { observer -> Disposable in
            
            guard let urlStr = url?.absoluteString else {
                observer.onError(NetworkError.invalidURL)
                return Disposables.create()
            }
            
            if let cacheData = RequestCache.shared[urlStr] {
                if let decodedData = try? JSONDecoder().decode(T.self, from: cacheData) {
                    observer.onNext(decodedData)
                } else {
                    observer.onError(NetworkError.decodeError)
                }
                return Disposables.create()
            } else {
                let task = URLSession.shared.dataTask(with: self) { data, resp, err in
                    guard let validData = data else {
                        observer.onError(err ?? NetworkError.noData)
                        return
                    }
                    
                    guard let decodedData = try? JSONDecoder().decode(T.self, from: validData) else {

                        observer.onError(NetworkError.decodeError)
                        return
                    }
                    
                    RequestCache.shared[urlStr] = validData
                    
                    observer.onNext(decodedData)
                    
                    observer.onCompleted()
                }
                
                task.resume()
                
                return Disposables.create {
                    task.cancel()
                }
            }
            
        }
    }
}
