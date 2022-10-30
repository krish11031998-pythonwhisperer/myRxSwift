//
//  ViewController.swift
//  RxSwiftApp
//
//  Created by Krishna Venkatramani on 22/10/2022.
//

import UIKit
import RxSwift
import RxRelay

enum Pages: String, CaseIterable {
    case filter = "Filter Photo"
    case task = "Task"
    case news = "News"
    case weather = "Weather"
    case rxView = "RxSwift Views"
}

class ViewController: UIViewController {

    private var selectedTab = BehaviorRelay(value: "")
    private var disposeBag: DisposeBag = .init()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.separatorStyle = .none
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.backgroundColor = .surfaceBackground
        view.setFittingConstraints(childView: tableView, insets: .zero)
        addObservers()
//        tableView.reloadData(buildDataSource())
        loadTable()
    }
    
    private func loadTable() {
        tableView.registerCell(cell: UITableViewCell.self, identifier: "cell")
        Observable<[Pages]>.of(Pages.allCases)
            .asDriver(onErrorJustReturn: [])
            .drive(tableView.rx.items(cellIdentifier: "cell")) { _, model, cell in
                let label = model.rawValue.medium(size: 20).generateLabel
                cell.contentView.addSubview(label)
                cell.contentView.setFittingConstraints(childView: label, insets: .init(vertical: 10, horizontal: 15))
                cell.backgroundColor = .surfaceBackground
                cell.selectionStyle = .none
            }
            .disposed(by: disposeBag)
    }
    
    private func addObservers() {
        tableView.rx.itemSelected.subscribe { [weak self] in
            guard let `self` = self,
                  let item = $0.element
            else { return }
            
            if let cell = self.tableView.cellForRow(at: item) {
                cell.layer.animate(animation: .bouncy(duration: 0.1)) {
                    let type = Pages.allCases[item.row]
                    switch type {
                    case .filter:
                        self.navigateTo(PhotoFilterSelector())
                    case .task:
                        self.navigateTo(TaskViewController())
                    case .news:
                        self.navigateTo(NewsViewController())
                    case .weather:
                        self.navigateTo(WeatherViewController())
                    case .rxView:
                        self.navigateTo(RxDataSourceExample())
                    }
                }
            }
        }.disposed(by: disposeBag)
    }
    
    private func click(_ val: String) {
        selectedTab.accept(val)
    }

}

