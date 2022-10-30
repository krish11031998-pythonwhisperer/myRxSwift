//
//  MainTabBar.swift
//  RxSwift
//
//  Created by Krishna Venkatramani on 22/10/2022.
//

import Foundation
import UIKit


class MainTabBar: UITabBar {
    
    override func draw(_ rect: CGRect) {
        let path = UIBezierPath(roundedRect: .init(origin: .init(x: 10, y: 0), size: .init(width: rect.width - 20, height: rect.height - 30)), cornerRadius: 20)
        
        let shape = CAShapeLayer()
        shape.path = path.cgPath
        shape.fillColor = UIColor.white.cgColor
        shape.strokeColor = UIColor.clear.cgColor
        shape.shadowColor = UIColor.black.cgColor
        shape.shadowOpacity = 0.35
        shape.shadowOffset = .init(width: 0, height: 1.5)
        shape.shadowRadius = 5
        layer.insertSublayer(shape, at: 0)
    }
}
