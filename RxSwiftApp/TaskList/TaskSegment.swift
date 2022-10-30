//
//  TaskSegment.swift
//  RxSwiftApp
//
//  Created by Krishna Venkatramani on 29/10/2022.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

private extension UIView {
    
    func moveCard(x: CGFloat) {
        let animation = CABasicAnimation(keyPath: "position.x")
        animation.toValue = layer.frame.midX + x
        animation.isRemovedOnCompletion = false
        animation.fillMode = .forwards
        layer.add(animation, forKey: nil)
    }
    
}

class TaskSegment: UIView {
    
    private var buttons: [UIView] = []
    private let segments: [String]
    private lazy var selectedView: UIView = { .init() }()
    private var selectedIdx: Int = 0
    public var selectedPriority: PublishSubject<String> = .init()
    
    init(segments: [String]) {
        self.segments = segments
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        self.segments = []
        super.init(coder: coder)
        setupView()
    }
    
    override func draw(_ rect: CGRect) {
        border(color: .gray, borderWidth: 1, cornerRadius: rect.height.half)
        selectedView.setFrame(.init(width: rect.width/CGFloat(segments.count), height: rect.height))
        selectedView.clippedCornerRadius = rect.height.half
        selectedView.backgroundColor = .gray
    }
    
    private func setupView() {
        setupButtons()
        selectedPriority.onNext(segments[selectedIdx])
        let stack = UIStackView.HStack(subViews: buttons, spacing: 10, alignment: .center)
        stack.distribution = .fillEqually
        addSubview(stack)
        setFittingConstraints(childView: stack, insets: .zero)
        insertSubview(selectedView, belowSubview: stack)
    }
    
    private func setupButtons() {
        segments.enumerated().forEach { segment in
            let label = segment.element.medium(size: 20).generateLabel
            label.textAlignment = .center
            let button = label.buttonify {
                self.handler(idx: segment.offset)
            }
            buttons.append(button)
        }
    }
    
    private func handler(idx: Int) {
        let unitWidth: CGFloat = frame.width/CGFloat(segments.count)
        selectedView.moveCard(x: unitWidth * CGFloat(idx))
        selectedPriority.onNext(segments[idx])
    }
    
    deinit {
        print("DEINT \(Self.self)")
    }
    
}
