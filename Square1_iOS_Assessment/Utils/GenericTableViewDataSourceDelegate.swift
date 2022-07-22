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
    
    public typealias CellConfigurator = ((Model, Cell) -> Void)
    public typealias DidSelectItem = ((Int) -> Void)
    public typealias DidSwipeItem = ((IndexPath, Cell?) -> UISwipeActionsConfiguration?)
    public typealias LoadMore = ((Bool) -> Void)
    public var didSelectItemAt: DidSelectItem?
    public var didSwipeItemAt: DidSwipeItem?
    public var loadMore: LoadMore?
    public var itemDisplayLimit: Int?
    
    // MARK: Internal
    
    var models: [Model]
    
    // MARK: Private
    
    private let cellConfigurator: CellConfigurator
    
    // MARK: Initialiser
    
    public init(models: [Model], cellConfigurator: @escaping CellConfigurator) {
        self.models = models
        self.cellConfigurator = cellConfigurator
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemDisplayLimit ?? models.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let model = models[indexPath.row]
        let cell = tableView.dequeue(Cell.self, for: indexPath)
        
        cellConfigurator(model, cell)
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelectItemAt?(indexPath.item)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == models.count - 5 {
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

