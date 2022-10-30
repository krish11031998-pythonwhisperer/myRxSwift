//
//  taskView.swift
//  RxSwiftApp
//
//  Created by Krishna Venkatramani on 29/10/2022.
//

import Foundation
import UIKit
import RxSwift
import RxRelay
import RxCocoa

extension BehaviorRelay where Element == Array<Codable> {
    func update(_ newElement: Element.Element) {
        var newValue = value
        newValue.append(newElement)
        accept(newValue)
    }
}


class TaskViewController: UIViewController {
    
    private var tasks: [TaskModel] = []
    private var tasksRelay: BehaviorRelay<Array<TaskModel>> = .init(value: [.init(text: "Complete RxSwift", priority: "High")])
    private let bag: DisposeBag = .init()
    private var selectedPriority: BehaviorRelay<String> = .init(value: "All")
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .surfaceBackground
        return tableView
    }()
    
    private lazy var addButton: UIBarButtonItem = {
        .init(image: .init(systemName: "plus"), style: .plain, target: self, action: #selector(addTask))
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        view.setFittingConstraints(childView: tableView, insets: .zero)
//        tableView.reloadData(buildDatasource())
        addObservable()
        standardNavBar(title: "Task", rightBarButton: addButton, isTransparent: false)
    }
    
    private func addObservable() {
        tasksRelay
            .map { $0.filter { [weak self] in
                guard let `self` = self else { return false }
                return self.selectedPriority.value == "All" || $0.priority == self.selectedPriority.value
            }}
            .subscribe { [weak self] in
                guard let newTasks = $0.element else { return }
                self?.tasks = newTasks
                DispatchQueue.main.async {
                    self?.reloadTable()
                }
            }
            .disposed(by: bag)
        

        segmentedControl
            .selectedPriority
            .subscribe { [weak self] in
                print("(DEBUG) print on selectedPriority : ", $0.element)
                guard let priority = $0.element else { return }
                self?.tasks = (self?.tasksRelay.value.filter { priority == "All" || $0.priority == priority}) ?? []
                DispatchQueue.main.async {
                    self?.reloadTable()
                }
            }.disposed(by: bag)
    }
    
    private var segmentedControl: TaskSegment = {
        let segmentView: TaskSegment = .init(segments: ["All", "High", "Medium", "Low"])
        segmentView.setHeight(height: 40)
        return segmentView
    }()
    
//    private var section: TableSection {
//        let cells: [TableCellProvider] = tasks.compactMap {
//            let stack: UIView = .HStack(subViews: [$0.text.medium(color: .textColorInverse, size: 18).generateLabel, .spacer(), $0.priority.medium(color: .gray, size: 15).generateLabel], spacing: 10, alignment: .center).embedInView(insets: .init(by: 15))
//            stack.backgroundColor = .surfaceBackgroundInverse
//            stack.clippedCornerRadius = 12
//            return TableRow<CustomTableCell>(.init(view: stack, inset: .init(by: 10)))
//        }
//        return .init(rows: cells, customHeader: segmentedControl.embedInView(insets: .init(by: 10)))
//    }
//
//    private func buildDatasource() -> TableViewDataSource {
//        .init(sections: [section])
//    }
    
    private func reloadTable() {
//        tableView.reloadData(buildDatasource())
        tasksRelay
            .bind(to: tableView.rx.items) { tv, _, item in
                let cell: TaskCell = tv.dequeueCell()
                cell.configure(with: item)
                return cell
            }
            .disposed(by: bag)
    }
    
    private func updateTable() {
        tableView.reloadSections(.init(integer: 0), with: .none)
    }
    
    @objc func addTask() {
        let addtask = AddTaskManager()
        addtask.taskObservable.subscribe { [weak self] model in
            guard let `self` = self ,let model = model.element else { return }
            var newValue = self.tasksRelay.value
            newValue.append(model)
            self.tasksRelay.accept(newValue)
        }.disposed(by: bag)
        presentCard(controller: addtask, withNavigation: true) {
            print("(DEBUG) Dismiss!")
        }
    }
    
    deinit {
        print("DEINT \(Self.self)")
    }
    
}


class TaskCell: ConfigurableCell {
    
    private lazy var taskName: UILabel = { .init() }()
    private lazy var taskPriority: UILabel = { .init() }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    func setupView() {
        let stack: UIView = .HStack(subViews: [taskName, .spacer(), taskPriority], spacing: 10, alignment: .center).embedInView(insets: .init(by: 15))
        stack.backgroundColor = .surfaceBackgroundInverse
        stack.clippedCornerRadius = 12
        contentView.addSubview(stack)
        contentView.setFittingConstraints(childView: stack, insets: .init(by: 10))
    }
    
    func configure(with model: TaskModel) {
        model.text.medium(color: .textColorInverse, size: 18).render(target: taskName)
        model.priority.medium(color: .gray, size: 15).render(target: taskPriority)
    }
}
