//
//  RxDataSourceExample.swift
//  RxSwiftApp
//
//  Created by Krishna Venkatramani on 30/10/2022.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import RxDataSources

//protocol DataCellProvider {
//    associatedtype Cell: ConfigurableCell
//    var cell: TableRow<Cell> { get }
//}

struct CellNameModel {
    let name: String
}

//extension CellNameModel: DataCellProvider {
//    var cell: TableRow<TextCell> {
//        .init(self)
//    }
//}
//
//extension CellNameModel: IdentifiableType {
//    typealias Identity = String
//    var identity: String { name }
//}
//
//extension CellNameModel: Equatable {
//    static func == (lhs: Self, rhs: Self) -> Bool {
//        lhs.identity == rhs.identity
//    }
//}

//MARK: - SectionModel

//struct SectionModel {
//    var title: String
//    var items: [CellNameModel]
//}
//
//extension SectionModel: AnimatableSectionModelType {
//
//    typealias Item = CellNameModel
//
//    var identity: String { title }
//
//    init(original: SectionModel, items: [CellNameModel]) {
//        self = original
//        self.items = items
//    }
//}

//MARK: - RxDataSourceExample

class RxDataSourceExample: UIViewController {
    
    private var disposeBag: DisposeBag = .init()
    
    private lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.backgroundColor = .surfaceBackground
        table.separatorStyle = .none
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        view.addSubview(tableView)
        view.setFittingConstraints(childView: tableView, insets: .zero)
        loadTable()
    }
    
//    private var section: SectionModel {
//        .init(title: "Test", items: ["TestOne","TestTwo","TestThree"].compactMap(CellNameModel.init))
//    }
    
    private var dataSource: RxTableViewSectionedAnimatedDataSource<TableSection> {
//        RxTableViewSectionedAnimatedDataSource<TableSection>(
//            animationConfiguration: .init(insertAnimation: .fade, reloadAnimation: .none)) { ds, tv, _, item in
//                return item.cell.tableView(tv)
//            } titleForHeaderInSection: { ds, index in
//                return ds.sectionModels[index].title
//            }
        RxTableViewSectionedAnimatedDataSource<TableSection> (
            
        )

    }
    
    private func loadTable() {
//        let data = Observable<[SectionModel]>.just([section])
//            .asDriver(onErrorJustReturn: [])
//
//        data
//            .drive(tableView.rx.items(dataSource: dataSource))
//            .disposed(by: disposeBag)
    }
    
}

//MARK: - TestTextCell
class TextCell: ConfigurableCell {
    
    private lazy var label: UILabel = { .init() }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        contentView.addSubview(label)
        contentView.setFittingConstraints(childView: label, insets: .init(vertical: 10, horizontal: 15))
        selectionStyle = .none
        backgroundColor = .surfaceBackground
    }
    
    func configure(with model: CellNameModel) {
        model.name.medium(size: 15).render(target: label)
    }
}
