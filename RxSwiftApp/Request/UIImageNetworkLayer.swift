//
//  UIImageNetworkLayer.swift
//  RxSwiftApp
//
//  Created by Krishna Venkatramani on 26/10/2022.
//

import Foundation
import UIKit
import RxSwift

struct ImageCache: RequestCacheSubscript {
    
    private let cache: NSCache<NSString,NSData> = { .init() }()
    
    public static var shared: Self = .init()
    
    subscript(urlStr: String) -> Data? {
        get {
            cache.object(forKey: urlStr as NSString) as? Data
        }
        
        set {
            
            guard let validData = newValue as? NSData else { return }
            
            if let _ = cache.object(forKey: urlStr as NSString) {
                cache.removeObject(forKey: urlStr as NSString)
            }
            
            cache.setObject(validData, forKey: urlStr as NSString)
        }
    }
}


extension UIImage {
    
    
    static func downloadImage(urlStr: String) -> Observable<UIImage> {
        guard let url = URL(string: urlStr) else {
            return Observable.empty()
        }
        
        return Observable<UIImage>.create { observer -> Disposable in
            let task = URLSession.shared.dataTask(with: url) { data, resp, err in
                guard let validData = data else {
                    observer.onError(err ?? NetworkError.noData)
                    return
                }
                
                guard let decodedData = UIImage(data: validData) else {
                    observer.onError(NetworkError.decodeError)
                    return
                }
                
                ImageCache.shared[urlStr] = validData
                
                observer.onNext(decodedData)
                
                observer.onCompleted()
            }
            
            task.resume()
            
            return Disposables.create {
                task.cancel()
            }
        }
        
    }
    
    static let bag: DisposeBag = .init()
    
    static func loadImage<T: AnyObject>(url: String, for obj: T, at: ReferenceWritableKeyPath<T,UIImage?>) {
        if let cachedData = ImageCache.shared[url], let decodedImage = UIImage(data: cachedData) {
            obj[keyPath: at] = decodedImage
        } else {
            downloadImage(urlStr: url)
                .debug(url, trimOutput: true)
                .subscribe { img in
                    DispatchQueue.main.async {
                        obj[keyPath: at] = img
                    }
                } onError: { err in
                    print(err.localizedDescription)
                }
                .disposed(by: bag)
        }
    }
    
}
