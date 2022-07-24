//
//  GenericTableViewDataSourceDelegate.swift
//  Square1_iOS_Assessment
//
//  Created by Anthony Odu on 2022/7/22.
//

import UIKit

// MARK: - GenericTableViewDataSourceDelegate
public final class GenericTableViewDataSourceDelegate<Model, Cell: UITableViewCell>: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: Public
    public typealias CellConfigurator = ((Model?, Cell) -> Void)
    public typealias LoadMore = ((Bool) -> Void)
    public var loadMore: LoadMore?
    public var itemDisplayLimit: Int?
    
    // MARK: Internal
    var models: [Int: [Model]] = [:]
    var items: [Int] = []
    var showHeaderView: Bool
    
    // MARK: Private
    private let cellConfigurator: CellConfigurator
    
    // MARK: Initialiser
    public init(models: [Int: [Model]],
                items: [Int],
                showHeaderView: Bool = false,
                cellConfigurator: @escaping CellConfigurator) {
        self.models = models
        self.items = items
        self.showHeaderView = showHeaderView
        self.cellConfigurator = cellConfigurator
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        models.count
    }
    
    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return  showHeaderView ? "List of cities- Page: \(items[section])".uppercased() : nil
    }
    
    public func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let headerView = view as! UITableViewHeaderFooterView
        headerView.textLabel?.font = .boldSystemFont(ofSize: 14)
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemDisplayLimit ?? models[items[section]]?.count ?? 0
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = models[items[indexPath.section]]?[indexPath.row]
        let cell = tableView.dequeue(Cell.self, for: indexPath)
        
        cellConfigurator(model, cell)
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {

        if indexPath.section == tableView.numberOfSections - 1 {
            if indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1 {
                loadMore?(true)
            } else {
                loadMore?(false)
            }
        }
    }
}

