////
////  TableDataSource.swift
////  ZeamFinance
////
////  Created by Krishna Venkatramani on 05/10/2022.
////
//
//import Foundation
//import UIKit
//
//public class TableViewDataSource: NSObject {
//	
//	public let sections: [TableSection]
//	
//	public init(sections: [TableSection]) {
//		self.sections = sections
//	}
//
//	public lazy var indexPaths: [IndexPath] = {
//		var paths = [IndexPath]()
//		sections.enumerated().forEach { section in
//			section.element.rows.enumerated().forEach { row in
//				paths.append(.init(row: row.offset, section: section.offset))
//			}
//		}
//		
//		return paths
//	}()
//}
//
//
//extension TableViewDataSource: UITableViewDataSource {
//	
//	public func numberOfSections(in tableView: UITableView) -> Int { sections.count }
//	
//	public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { sections[section].rows.count }
//
//	public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//		sections[indexPath.section].rows[indexPath.row].tableView(tableView, cellForRowAt: indexPath)
//	}
//	
//	public func tableView(_ tableView: UITableView, updateRowAt indexPath: IndexPath) {
//		sections[indexPath.section].rows[indexPath.row].tableView(tableView, updateRowAt: indexPath)
//	}
//	
//	
//	public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//		sections[section].customHeader ?? sections[section].title?.sectionHeader(size: 15).generateLabel.embedInView(insets: .init(by: 10))
//	}
//	
//	public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//		return nil
//	}
//	
//	public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//		UITableView.automaticDimension
//	}
//}
//
//
//extension TableViewDataSource: UITableViewDelegate {
//	public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//		let row = sections[indexPath.section].rows[indexPath.row]
//		row.didSelect(tableView, indexPath: indexPath)
//	}
//	
//}
