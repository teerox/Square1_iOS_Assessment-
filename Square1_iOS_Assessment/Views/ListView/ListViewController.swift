//
//  ListViewController.swift
//  Square1_iOS_Assessment
//
//  Created by Anthony Odu on 2022/7/21.
//

import UIKit
import Combine

class ListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.register(TableViewCell.self)
            tableView.rowHeight = 50
        }
    }
    
    private var dataSource: GenericTableViewDataSourceDelegate<TableViewValue, TableViewCell>?
    private var page: Int = 1
    private var lastPage: Int = 1
    private var viewModel: ViewModel?
    private var cancellableSet: Set<AnyCancellable> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = ViewModel()
        setUpData()
    }
    
    func setUpData() {
        viewModel?.fetchFromDB()
        viewModel?.itemsFromDb
            .sink(receiveValue: { result in
                self.didFetchData(data: result)
            })
            .store(in: &cancellableSet)
    }
    
    private func handleTableViewDataSource(model: ItemDataSource) -> GenericTableViewDataSourceDelegate<TableViewValue, TableViewCell> {
        return GenericTableViewDataSourceDelegate<TableViewValue, TableViewCell>(
            models: model.sections, items: model.items, showHeaderView: true) { (result, cell) in
                cell.attachView(value: result)
            }
    }
    
    private func handleTableView() {
        tableView.delegate = dataSource
        tableView.dataSource = dataSource
    }
    
    private func didFetchData(data: [TableViewValue]) {
        let values: ItemDataSource = .init(data: data)
        dataSource = handleTableViewDataSource(model: values)
        handleTableView()
        tableView.reloadData()
        self.lastPage = data.first?.lastPage ?? 1
        self.page = data.last?.currentPage ?? 1
        loadMore()
    }
    
    private func loadMore() {
        
        dataSource?.loadMore = { [weak self] value in
            guard let self = self else { return }
            if value {
                self.page += 1
                if self.page <= self.lastPage {
                    // make Request update Table
                    self.viewModel?.fetchDataFromApi(page: self.page)
                }
            }
        }
    }
}
