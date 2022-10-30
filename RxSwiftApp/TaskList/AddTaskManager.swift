//
//  AddTaskManager.swift
//  RxSwiftApp
//
//  Created by Krishna Venkatramani on 29/10/2022.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift

class AddTaskManager: UIViewController {
    
    private var task: PublishSubject<TaskModel> = .init()
   
    public var taskPriority: BehaviorRelay<String> = .init(value: "")
    private var bag: DisposeBag = .init()
    
    public var taskObservable: Observable<TaskModel> {
        task.asObserver()
    }
    
    private lazy var segmentControl: TaskSegment = {
        let control = TaskSegment(segments: ["All","High","Medium","Low"])
        control.selectedPriority.bind(to: taskPriority).disposed(by: bag)
        control.setHeight(height: 40)
        return control
    }()
    
    private lazy var textField: UITextField = {
        let field = UITextField()
        "Add a Task".medium(size: 12).render(target: field)
        field.font = CustomFonts.medium.fontBuilder(size: 15)
        field.textColor = .textColor
        field.setHeight(height: 50)
        field.delegate = self
        return field
    }()
    
    private lazy var button: UIView = {
        let buttonLabel = "Add Task".medium(size: 20).generateLabel
        buttonLabel.textAlignment = .center
        let buttonView = buttonLabel.embedIntoCard(.success500, inset: .init(vertical: 10, horizontal: 20), cornerRadius: 10, clipped: true)
        let button = buttonView.buttonify(handler: updateAndDismiss)
        return button
    }()
    
    private lazy var progressBar: ProgressBar = {
        let progressbar = ProgressBar(bgColor: .clear, fillColor: .surfaceBackgroundInverse, borderWidth: 1, borderColor: .surfaceBackgroundInverse)
        progressbar.setHeight(height: 15)
        return progressbar
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewCornerRadius = 32
        view.addShadow()
        view.backgroundColor = .surfaceBackground
        preferredContentSize = .init(width: .totalWidth, height: .totalHeight.half)
        
        setupNavbar()
        setupView()
    }
    
    
    private func setupNavbar() {
        mainPageNavBar(title: "Add Task", rightBarButton: nil, isTransparent: false, isModal: true, barColor: .surfaceBackground)
        navigationController?.additionalSafeAreaInsets = .init(top: 20, left: 0, bottom: 10, right: 0)
    }
    
    private func setupView() {
        let textFieldView = textField.embedInView(insets: .init(vertical: 5, horizontal: 15))
        textFieldView.border(color: .surfaceBackgroundInverse, borderWidth: 1, cornerRadius: 16)
        let stack: UIStackView = .VStack(subViews: [segmentControl, textFieldView, progressBar, button], spacing: 20)
        stack.setCustomSpacing(15, after: textFieldView)
        view.addSubview(stack)
        view.setFittingConstraints(childView: stack, top: navbarHeight + 10, leading: 10, trailing: 10, height: stack.compressedSize.height)
    }
    
    private func updateAndDismiss() {
        guard let text = textField.text else { return }
        task.onNext(.init(text: text, priority: taskPriority.value))
        dismiss(animated: true)
    }
    
    deinit {
        print("DEINT \(Self.self)")
    }
}


extension AddTaskManager: UITextFieldDelegate {
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let count = textField.text?.count ?? 0
        let progress = (CGFloat(count)/CGFloat(10)).boundTo(lower: 0, higher: 1)
        progressBar.setProgress(progress: progress, color: progress < 0.3 ? .error500 : progress < 0.7 ? .warning500 : .success500)
        
        return true
    }
}
