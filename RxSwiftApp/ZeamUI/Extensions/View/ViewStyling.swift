//
//  ViewStyling.swift
//  CountdownTimer
//
//  Created by Krishna Venkatramani on 20/09/2022.
//

import Foundation
import UIKit

enum CornerRadius {
	case top
	case bottom
	case all
	
	var corners: CACornerMask {
		switch self {
		case .top: return [.layerMinXMinYCorner,.layerMaxXMinYCorner]
		case .bottom: return [.layerMinXMaxYCorner,.layerMaxXMaxYCorner]
		case .all: return [.layerMinXMinYCorner,.layerMaxXMinYCorner,.layerMinXMaxYCorner,.layerMaxXMaxYCorner]
		}
	}
}

extension UIView {
	
	var userInterface: UIUserInterfaceStyle { traitCollection.userInterfaceStyle }
	
	var cornerRadius: CGFloat {
		get { layer.cornerRadius }
		set { layer.cornerRadius = newValue }
	}
	
	var clippedCornerRadius: CGFloat {
		get { layer.cornerRadius }
		set {
			layer.cornerRadius = newValue
			clipsToBounds = true
		}
	}
	func cornerRadius(_ val: CGFloat, corners: CornerRadius) {
		cornerRadius = val
		layer.maskedCorners = corners.corners
	}
	
	func border(color: UIColor = .clear, borderWidth: CGFloat = 1, cornerRadius: CGFloat? = nil) {
		layer.borderColor = color.cgColor
		layer.borderWidth = borderWidth
		if let validCornerRadius = cornerRadius {
			self.clippedCornerRadius = validCornerRadius
		}
	}
	
	var defaultBlurStyle: UIBlurEffect.Style {
		userInterface == .dark ? .systemThinMaterialLight : .systemUltraThinMaterialDark
	}
	
	func addGradientView(colors: [UIColor], frame: CGRect? = nil) {
		let gradientLayer = CAGradientLayer()
		gradientLayer.colors = colors.map(\.cgColor)

		let view = UIView(frame: bounds)
		gradientLayer.frame = bounds
		view.layer.insertSublayer(gradientLayer, at: 0)
		insertSubview(view, at: 0)
		setFittingConstraints(childView: view, insets: .zero)
	}
	
	func addBlurView(_ _style: UIBlurEffect.Style? = nil) {
		let style = _style ?? defaultBlurStyle
		let blur = UIBlurEffect(style: style)
		let blurView = UIVisualEffectView(effect: blur)
		addSubview(blurView)
		setFittingConstraints(childView: blurView, insets: .zero)
		sendSubviewToBack(blurView)
	}
	
	func addShadow(){
		self.layer.shadowColor = UIColor.surfaceBackgroundInverse.cgColor
        self.layer.shadowOpacity = 0.2
		self.layer.shadowOffset = .init(width: 0, height: 0)
		self.layer.shadowRadius = 1
	}
	
	func addShadowBackground(inset: UIEdgeInsets = .zero, cornerRadius: CGFloat = 8) {
		let view = UIView()
		view.addShadow()
		view.border(color: .clear, borderWidth: 1, cornerRadius: cornerRadius)
		addSubview(view)
		sendSubviewToBack(view)
		setFittingConstraints(childView: view, insets: inset)
	}
	
	var compressedSize: CGSize {
		systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
	}
	
	func setCompressedSize() {
		let size = compressedSize
		setFrame(width: size.width, height: size.height)
	}
	
	//MARK: - GraphicRenderer
	var snapshot:UIImage {
		let renderer = UIGraphicsImageRenderer(bounds: bounds)
		let img =  renderer.image { context in
			layer.render(in: context.cgContext)
		}
		return img
	}
	//MARK: - Circular
	
	var circleFrame: CGRect {
		get { bounds }
		set {
			frame = newValue
			cornerRadius = min(newValue.width, newValue.height).half
			clipsToBounds = true
		}
	}
	
	convenience init(circular: CGRect, background: UIColor) {
		self.init()
		circleFrame = circular
		backgroundColor = background
		clipsToBounds = true
	}
}

