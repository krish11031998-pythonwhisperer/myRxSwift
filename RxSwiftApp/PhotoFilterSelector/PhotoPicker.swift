//
//  PhotoPicker.swift
//  RxSwiftApp
//
//  Created by Krishna Venkatramani on 24/10/2022.
//

import Foundation
import UIKit
import Photos
import RxSwift

enum ImageLoadError: Error {
    case cantRequestImage
}

extension PHAsset {
    
    func requestImage(size: CGSize, completion: @escaping Response<UIImage>) {
        PHImageManager.default().requestImage(for: self, targetSize: size, contentMode: .aspectFill, options: nil) { img, options in
            guard let img = img,
                  let options = options
            else {
                completion(.failure(ImageLoadError.cantRequestImage))
                return
                
            }
            if !(options["PHImageResultIsDegradedKey"] as? Bool ?? false) {
                completion(.success(img))
            } else {
                completion(.failure(ImageLoadError.cantRequestImage))
            }
        }
    }
    
}

class PhotoPicker: UIViewController {
    
    private let selectedPhotoSubject = PublishSubject<UIImage>()
    var selectedPhoto: Observable<UIImage> {
        return selectedPhotoSubject.asObservable()
    }
    private var disposeBag = DisposeBag()
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = .init(squared: .totalWidth * 0.3)
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = .init(by: 10)
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.showsVerticalScrollIndicator = false
        return collection
    }()
    private var imgAssets: [PHAsset] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollection()
        preferredContentSize = .init(width: .totalWidth, height: .totalHeight * 0.75)
        mainPageNavBar(title: "Photo Picker", isTransparent: true, isModal: true)
        navigationController?.additionalSafeAreaInsets = .init(top: 10, left: 0, bottom: 0, right: 0)
//        fetchImages()
    }
    
    private func setupCollection() {
        view.addSubview(collectionView)
        view.setFittingConstraints(childView: collectionView, insets: .zero)
        view.backgroundColor = .surfaceBackgroundInverse
    }
    
    private func fetchImages() {
        let assets = PHAsset.fetchAssets(with: .image, options: nil)
        assets.enumerateObjects { [weak self] object, count, stop in
            self?.imgAssets.append(object)
        }
        collectionView.reloadData(buildCollectionDataSource())
    }
    
    private var photoSection: CollectionSection? {
        return .init(cell: imgAssets.compactMap { image in
            let model: CustomCollectionCellModel = .init(view: imgView(image), inset: .zero) {
                image.requestImage(size: .init(squared: .totalWidth * 0.3)) { [weak self] result in
                    guard let img = result.data else { return }
                    DispatchQueue.main.async {
                        self?.selectedPhotoSubject.onNext(img)
                        self?.dismiss(animated: true)
                    }
                }
            }
            return CollectionItem<CustomCollectionCell>(model)
        })
    }
    
    private func buildCollectionDataSource() -> CollectionDataSource {
        .init(sections: [photoSection].compactMap { $0 })
    }
    
    private func imgView(_ image: PHAsset) -> UIView {
        let imageView = UIImageView()
        imageView.clippedCornerRadius = 12
        imageView.backgroundColor = .darkGray
        image.requestImage(size: .init(squared: .totalWidth * 0.3)) { result in
            guard let img = result.data else { return }
            DispatchQueue.main.async {
                imageView.image = img
            }
        }
        return imageView
    }
    
    deinit {
        print("Deinit!")
    }
}
