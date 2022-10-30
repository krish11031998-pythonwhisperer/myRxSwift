//
//  MainTabViewControlller.swift
//  RxSwift
//
//  Created by Krishna Venkatramani on 22/10/2022.
//

import Foundation
import UIKit

class MainTabViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tabBar = { () -> MainTabBar in
            let tabBar = MainTabBar()
            tabBar.delegate = self
            return tabBar
        }()
        
        setValue(tabBar, forKey: "tabBar")
        setViewControllers(setupTabBar(), animated: true)
        selectedIndex = 0
    }
    
    func setupTabBar() -> [UIViewController] {
        let vc = UINavigationController(rootViewController: ViewController())
        vc.tabBarItem = .init(title: nil, image: .init(systemName: "house"), selectedImage: .init(systemName: "house.fill"))
        return [vc]
    }
    
    
}
