//
//  WeatherViewController.swift
//  RxSwiftApp
//
//  Created by Krishna Venkatramani on 30/10/2022.
//

import Foundation
import UIKit
import RxSwift

class WeatherViewController: UIViewController {
    
    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.font = CustomFonts.bold.fontBuilder(size: 15)
        "Location...".medium(color: .textColor.withAlphaComponent(0.5), size: 15).render(target: textField)
//        textField.delegate = self
        return textField
    }()
    private var disposeBag: DisposeBag = .init()
    private lazy var tempView: UILabel = { .init() }()
    private lazy var tempDescription: UILabel = { .init() }()
    
    private var bag: DisposeBag = .init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .surfaceBackground
        standardNavBar(title: "Weather", isTransparent: false)
        setupView()
    }
    
    private func setupView() {
        let textFieldView = textField.embedInView(insets: .init(by: 15))
        textFieldView.border(color: .gray, borderWidth: 1, cornerRadius: 16)
        view.addSubview(textFieldView)

        view.setFittingConstraints(childView: textFieldView, top: navbarHeight + .safeAreaInsets.top + 20, leading: 20, trailing: 20, height: 50)
                
        let stack = UIStackView.VStack(subViews: [tempView, tempDescription], spacing: 20, alignment: .center)
        view.addSubview(stack)
        view.setFittingConstraints(childView: stack, leading: 30, trailing: 30, height: 100, centerY: 0)
        
        "Label".bold(size: 30).render(target: tempView)
        "Small Label".medium(size: 20).render(target: tempDescription)
        
        textField.rx
            .controlEvent(.editingDidEndOnExit)
            .asObservable()
            .compactMap { self.textField.text }
            .subscribe{
                guard let text = $0.element, !text.isEmpty else { return }
                print(text)
                self.fetchWeather(text: text)
            }
            .disposed(by: bag)
    }
    
}

//MARK: - UITextFieldDelegate
//extension WeatherViewController: UITextFieldDelegate {
//
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        return true
//    }
//
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        textField.resignFirstResponder()
//        fetchWeather()
//        return true
//    }
//
//}

//MARK: - WeatehrViewController

extension WeatherViewController {
    
    func fetchWeather(text: String) {
        let search  = WeatherAPI
            .weater(q: text)
            .executeRequest
//            .observe(on: MainScheduler.asyncInstance)
//            .subscribe { [weak self] in
//                guard let `self` = self, let weather = $0.element else { return }
//                print(weather)
//                weather.weather?.first?.main.bold(size: 20).render(target: self.tempDescription)
//                String(format: "%.2f K", weather.main?.temp ?? 0.0).bold(size: 30).render(target: self.tempView)
//            }
//            .disposed(by: disposeBag)
            .asDriver(onErrorJustReturn: .init(weather: nil, name: "", id: 0, visibility: 0, main: nil))
//            .drive { [weak self] in
//                guard let `self` = self else { return }
//                $0.weather?.first?.main.bold(size: 20).render(target: self.tempDescription)
//                String(format: "%.2f K", $0.main?.temp ?? 0.0).bold(size: 30).render(target: self.tempView)
//            }
//            .disposed(by: bag)
        
//        search.map { $0.weather?.first?.main.medium(size: 20) as? NSAttributedString }.driver(tempDescription.rx.attributedText).disposed(by: bag
        search.map { $0.weather?.first?.main.bold(size: 20) as? NSAttributedString }.drive(tempDescription.rx.attributedText).disposed(by: bag)
        search.compactMap { $0.main?.temp }.map { String(format: "%.2f F", $0).bold(size: 30) as? NSAttributedString }.drive(tempView.rx.attributedText).disposed(by: bag)
//        search.compactMap { $0.main?.temp }.map { String(format: "%.2f F", $0).bold(size: 30) as? NSAttributedString }.bind(to: tempView.rx.attributedText).disposed(by: bag)
    }
    
}
