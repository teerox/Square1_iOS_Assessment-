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
        }
    }
    
    private var dataSource: GenericTableViewDataSourceDelegate<TableViewValue, TableViewCell>?
    private var page: Int = 1
    private var totalPage: Int = 1
    private var viewModel: ViewModel?
    private var cancellableSet: Set<AnyCancellable> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = ViewModel()
    }
    
    
    func setUpData() {
        viewModel?.fetchDataFromApi(page: page)
        viewModel?.fetchFromDB()
        viewModel?.updateItem()
        viewModel?.itemsFromDb
            .sink(receiveValue: { result in
                self.didFetchData(data: result)
            })
            .store(in: &cancellableSet)
    }
    
    private func handleTableViewDataSource(model: [TableViewValue]) -> GenericTableViewDataSourceDelegate<TableViewValue, TableViewCell> {
        return GenericTableViewDataSourceDelegate<TableViewValue, TableViewCell>(
            models: model) { (result, cell) in
                cell.attachView(value: result)
            }
    }
    
    private func handleTableView() {
        tableView.delegate = dataSource
        tableView.dataSource = dataSource
    }
    
    private func didFetchData(data: [TableViewValue]) {
        dataSource = handleTableViewDataSource(model: data)
        dataSource?.didSelectItemAt = handleDidSelect(data: data)
        handleTableView()
        tableView.reloadData()
        loadMore()
    }
    
    private func didSelectTransaction(row: Int) {
        /// handle did select row
    }
    
    private func handleDidSelect(data: [TableViewValue]) -> ((Int) -> Void) {
        return { [weak self] row in
            guard let self = self else { return }
            self.didSelectTransaction(row: row)
        }
    }
    
    private func loadMore() {
        
        dataSource?.loadMore = { [weak self] value in
            guard let self = self else { return }
            if value {
                self.page += 1
                if self.page <= self.totalPage {
                    // make Request update Table
                    self.setUpData()
                }
            }
        }
    }
}
