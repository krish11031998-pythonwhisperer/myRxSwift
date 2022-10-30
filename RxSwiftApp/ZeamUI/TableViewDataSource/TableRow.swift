//
//  TableRow.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 21/09/2022.
//

import Foundation
import UIKit
import Differentiator

typealias ConfigurableCell = Configurable & UITableViewCell

public protocol TableCellProvider {
	func tableView(_ tableView: UITableView) -> UITableViewCell
	func tableView(_ tableView: UITableView, updateRowAt indexPath: IndexPath)
	func didSelect(_ tableView: UITableView, indexPath: IndexPath)
}

class TableRow<Cell: ConfigurableCell>: TableCellProvider {
    
    var model: Cell.Model
    
	init(_ model: Cell.Model) {
		self.model = model
	}
	
	func tableView(_ tableView: UITableView) -> UITableViewCell {
		let cell: Cell = tableView.dequeueCell()
		cell.configure(with: model)
		return cell
	}
	
	func tableView(_ tableView: UITableView, updateRowAt indexPath: IndexPath) {
		let cell = tableView.cellForRow(at: indexPath) as? Cell
		cell?.configure(with: model)
	}
	
	func didSelect(_ tableView: UITableView, indexPath: IndexPath) {
		guard let cell = tableView.cellForRow(at: indexPath) as? Cell,
			  let actionProvider = model as? ActionProvider,
			  let action = actionProvider.action
		else { return }
		cell.layer.animate(animation: .bouncy()) {
			action()
		}
	}
	
}

extension TableRow: IdentifiableType {
    typealias Identity = String
    
    var identity: String { Cell.name }
    
    
}
