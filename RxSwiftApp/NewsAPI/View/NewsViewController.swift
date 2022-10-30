//
//  NewsViewController.swift
//  RxSwiftApp
//
//  Created by Krishna Venkatramani on 26/10/2022.
//

import Foundation
import UIKit
import RxSwift


class NewsViewController: UIViewController {
    
    private var news: [NewsModel]?
    private let disposeBag: DisposeBag = .init()
    private lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.separatorStyle = .none
        table.rowHeight = UITableView.automaticDimension
        table.showsVerticalScrollIndicator = false
        table.backgroundColor = .surfaceBackground
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        view.setFittingConstraints(childView: tableView, insets: .zero)
        fetchNews()
        standardNavBar(title: "News", isTransparent: false)
    }
    
    func fetchNews() {
        let news = NewsAPIEndpoint
            .topHeadline(country: "us")
            .executeRequest
            .asDriver(onErrorJustReturn: .init(status: "", totalResults: 0, articles: []))
        
        news.map { $0.articles }.drive(tableView.rx.items) { tv, item, data in
            let cell: NewsCell = tv.dequeueCell()
            cell.configure(with: data)
            return cell
        }
        .disposed(by: disposeBag)
        
    }
    
//    var newsSection: TableSection? {
//        guard let news = news else { return nil }
//        return .init(rows: news.map { TableRow<NewsCell>($0)})
//    }
//    
//    func buildDataSource() -> TableViewDataSource {
//        .init(sections: [newsSection].compactMap { $0 })
//    }
    
}
