//
//  UIViewController.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 24/09/2022.
//

import Foundation
import UIKit

//protocol AnyTableView: AnyObject {
//	func setupHeaderView(view: UIView)
//	func reloadTableWithDataSource(_ dataSource: TableViewDataSource)
//	func refreshTableView()
//}
//
//extension AnyTableView {
//	func setupHeaderView(view: UIView) { }
//	func refreshTableView() { }
//}


fileprivate extension UIBarButtonItem {
	
	static func closeButton(handler: Callback?) -> UIBarButtonItem {
		let img = UIImageView(frame: .init(origin: .zero, size: .init(squared: 25)))
		img.image = .init(systemName: "xmark")?.withTintColor(.surfaceBackgroundInverse, renderingMode: .alwaysOriginal)
		img.contentMode = .scaleAspectFit
		let button = img.buttonify(handler: handler)
		return .init(customView: button)
	}
}

extension UIViewController {
	
	func setupTransparentNavBar(color: UIColor = .clear, scrollColor: UIColor = .clear) {
		let navbarAppear: UINavigationBarAppearance = .init()
		navbarAppear.configureWithTransparentBackground()
		navbarAppear.backgroundImage = UIImage()
		navbarAppear.backgroundColor = color
		
		self.navigationController?.navigationBar.standardAppearance = navbarAppear
		self.navigationController?.navigationBar.compactAppearance = navbarAppear
		self.navigationController?.navigationBar.scrollEdgeAppearance = navbarAppear
		self.navigationController?.navigationBar.scrollEdgeAppearance?.backgroundColor = scrollColor
	}
	
	
	func showNavbar() {
		guard let navController = navigationController else { return }
		if navController.isNavigationBarHidden {
			navController.setNavigationBarHidden(false, animated: true)
		}
	}
	
	func hideNavbar() {
		guard let navController = navigationController else { return }
		if !navController.isNavigationBarHidden {
			navController.setNavigationBarHidden(true, animated: true)
		}
	}
	
	static func backButton(_ target: UIViewController) -> UIBarButtonItem {
		let buttonImg = UIImage.buttonLeftArrow.withTintColor(.surfaceBackgroundInverse, renderingMode: .alwaysOriginal).resized(size: .init(width: 31.5, height: 12))
		let imgView = UIImageView(image: buttonImg)
		imgView.frame = .init(origin: .zero, size: .init(squared: 32))
		imgView.contentMode = .center
		let barItem: UIBarButtonItem = .init(image: imgView.snapshot.withRenderingMode(.alwaysOriginal),
											 style: .plain,
											 target: target,
											 action: #selector(target.popViewController))
		return barItem
	}
	
	@objc
	func popViewController() {
		navigationController?.popViewController(animated: true)
	}
	
	func standardNavBar(title: String? = nil,
						leftBarButton: UIBarButtonItem? = nil,
						rightBarButton: UIBarButtonItem? = nil,
						isTransparent: Bool = true)
	{
		if isTransparent {
			setupTransparentNavBar()
		} else {
			setupTransparentNavBar(color: .surfaceBackground)
		}
		navigationItem.titleView = title?.sectionHeader(size: 20).generateLabel
		navigationItem.leftBarButtonItem = leftBarButton ?? Self.backButton(self)
		navigationItem.rightBarButtonItem = rightBarButton
	}
	
	func mainPageNavBar(title: String? = nil,
						rightBarButton: UIBarButtonItem? = nil,
						isTransparent: Bool = true,
                        isModal: Bool = false,
                        barColor: UIColor = .surfaceBackground)
	{
		if let titleView = title?.sectionHeader(size: 30).generateLabel {
			navigationItem.leftBarButtonItem = .init(customView: titleView)
		}
		setupTransparentNavBar(color: barColor, scrollColor: barColor)
		navigationItem.rightBarButtonItem = rightBarButton ?? (isModal ? .closeButton {
			self.navigationController?.popViewController(animated: true)
		} : nil)
	}

	func withNavigationController() -> UINavigationController {
		guard let navVC = self as? UINavigationController else { return .init(rootViewController: self) }
		return navVC
	}
	
	@objc
	func navigateTo(_ to: UIViewController) {
		navigationController?.pushViewController(to, animated: true)
	}
	
	var topMost: UIViewController? {
		switch self {
		case let navigation as UINavigationController:
			return navigation.visibleViewController?.topMost
		case let presented where presentedViewController != nil:
			return presented.presentedViewController?.topMost
		case let tabbar as UITabBarController:
			return tabbar.selectedViewController?.topMost
		default:
			return self
		}
	}
}

//MARK: - UIViewController Properties

extension UIViewController {
    
    var navbarHeight: CGFloat {
        (navigationController?.navigationBar.frame.height ?? 0) + (navigationController?.additionalSafeAreaInsets.top ?? 0)
    }
    
    var viewCornerRadius: CGFloat {
        get { view.cornerRadius }
        set {
            view.clippedCornerRadius = newValue
            navigationController?.navigationBar.cornerRadius(newValue, corners: .top)
            navigationController?.navigationBar.clipsToBounds = true
        }
    }
}


//MARK: - Presentation Extension

extension UIViewController {
	
	
	func presentCard(controller vc: UIViewController, withNavigation: Bool, onDismissal: Callback?) {
		if let currentCard = presentedViewController {
			currentCard.dismiss(animated: true) {
				DispatchQueue.main.async {
					self.presentCard(controller: vc, withNavigation: withNavigation, onDismissal: onDismissal)
				}
			}
		} else {
			let target = vc.withNavigationController()
			let presenter = PresentationViewController(presentedViewController: target, presenting: self, onDismissal: onDismissal)
			target.transitioningDelegate = presenter
			target.modalPresentationStyle = .custom
			present(target, animated: true)
		}
	}
	
}

//MARK: - UINavigation View Controller

//extension UINavigationController {
//	func tabBarItem(_ model: MainTabBarModel) -> Self {
//		tabBarItem = model.tabBarItem
//		return self
//	}
//}
