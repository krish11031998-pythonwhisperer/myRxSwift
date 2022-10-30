//
//  PhotoFilterSelector.swift
//  RxSwiftApp
//
//  Created by Krishna Venkatramani on 24/10/2022.
//

import Foundation
import UIKit
import Photos
import RxSwift

class PhotoFilterSelector: UIViewController {
    
    private var disposeBag: DisposeBag = .init()
    
    private lazy var button: UIButton = {
        let button = UIButton()
        button.backgroundColor = .blue
        button.clippedCornerRadius = 12
        return button
    }()
    
    private lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .gray
        view.contentMode = .scaleAspectFill
        view.clippedCornerRadius = 12
        return view
    }()
    
    private lazy var rightBarButton: UIBarButtonItem = {
        return .init(image: .init(systemName: "plus"), style: .plain, target: self, action: #selector(showImageSelector))
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        standardNavBar(title: "Photo Filter",rightBarButton: rightBarButton, isTransparent: false)
        setupView()
        hideTabBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        showTabBar()
        
    }
    
    private func setupView() {
        view.addSubview(button)
        view.backgroundColor = .white
        view.setFittingConstraints(childView: button, bottom: 50, width: 200, height: 75, centerX: 0)
        "Add Photo".medium(color: .white, size: 20).render(target: button)
        view.addSubview(imageView)
        view.setFittingConstraints(childView: imageView,leading: 10, trailing: 10, height: 300, centerX: 0, centerY: 0)
    }
    
    private func hideTabBar() {
        guard let tabBarView = navigationController?.tabBarController?.tabBar else { return }
        tabBarView.isHidden = true
    }

    private func showTabBar() {
        guard let tabBarView = navigationController?.tabBarController?.tabBar else { return }
        tabBarView.isHidden = false
    }
        
    @objc
    private func showImageSelector() {
        populatePhotos { [weak self] in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.presentCard(controller: PhotoPicker(), withNavigation: true) {
                    print("(DEBUG) dismissed!")
                }
            }
        }
    }
    
    private func populatePhotos(completion: @escaping Callback) {
        PHPhotoLibrary.requestAuthorization { status in
            if status == .authorized {
                completion()
            }
        }
    }
}

