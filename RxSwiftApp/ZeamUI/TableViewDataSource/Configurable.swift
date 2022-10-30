//
//  ConfigurableCell.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 21/09/2022.
//

import Foundation
import UIKit
import Differentiator

typealias Callback = () -> Void

protocol Configurable {
    associatedtype Model
	func configure(with model: Model)
	static var cellName: String? { get }
}

extension Configurable {
	static var cellName: String? { nil }
}

protocol ActionProvider {
	var action: Callback? { get }
}
