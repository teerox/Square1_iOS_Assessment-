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
    public typealias DidSelectItem = ((Int) -> Void)
    public typealias DidSwipeItem = ((IndexPath, Cell?) -> UISwipeActionsConfiguration?)
    public typealias LoadMore = ((Bool) -> Void)
    public var didSelectItemAt: DidSelectItem?
    public var didSwipeItemAt: DidSwipeItem?
    public var loadMore: LoadMore?
    public var itemDisplayLimit: Int?
    
    // MARK: Internal
    var models: [String: [Model]] = [:]
    var items: [String] = []
    
    // MARK: Private
    private let cellConfigurator: CellConfigurator
    
    // MARK: Initialiser
    public init(models: [String: [Model]], items: [String], cellConfigurator: @escaping CellConfigurator) {
        self.models = models
        self.items = items
        self.cellConfigurator = cellConfigurator
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        models.count
    }
    
    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return  items[section].uppercased()
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
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelectItemAt?(indexPath.item)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.section == models.count - 1 {
            loadMore?(true)
        }else {
            loadMore?(false)
        }
    }
    
    public func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let cell = tableView.cellForRow(at: indexPath) as? Cell
        return didSwipeItemAt?(indexPath, cell)
    }
}

