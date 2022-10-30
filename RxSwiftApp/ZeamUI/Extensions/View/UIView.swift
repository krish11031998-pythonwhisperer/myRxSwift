//
//  UIView.swift
//  ZeamFinance
//
//  Created by Krishna Venkatramani on 14/10/2022.
//

import Foundation
import UIKit

extension UIView {
	
	func embedIntoCard(_ bgColor: UIColor = .surfaceBackgroundInverse,
					inset: UIEdgeInsets = .init(by: 5),
                       cornerRadius: CGFloat = 8, clipped: Bool = true) -> UIView {
		let bgView = UIView()
		bgView.backgroundColor = bgColor
        if clipped {
            bgView.clippedCornerRadius = cornerRadius
        } else {
            bgView.cornerRadius = cornerRadius
        }
		
		bgView.addSubview(self)
		bgView.setFittingConstraints(childView: self, insets: inset)
		return bgView
	}
}


//MARK: - Array of views

extension Array where Element : UIView {
	
	func addToView(_ main: UIView) {
		if let stack = main as? UIStackView {
			forEach(stack.addArrangedSubview(_:))
		} else {
			forEach(main.addSubview(_:))
		}
	}
	
}
