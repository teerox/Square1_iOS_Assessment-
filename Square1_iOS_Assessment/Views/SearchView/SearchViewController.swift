//
//  SearchViewController.swift
//  Square1_iOS_Assessment
//
//  Created by Anthony Odu on 2022/7/23.
//

import UIKit
import Combine

class SearchViewController: UIViewController, UISearchBarDelegate {
    
    // MARK: - IBOutlet
    @IBOutlet weak var tableView: UITableView!{
        didSet {
            tableView.register(TableViewCell.self)
            tableView.rowHeight = 50
        }
    }
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    // MARK: - Variables
    private var dataSource: GenericTableViewDataSourceDelegate<Item, TableViewCell>?
    private var page: Int = 1
    private var totalPage: Int = 1
    private var viewModel: ViewModel?
    private var cancellableSet: Set<AnyCancellable> = []
    private var searchText = PassthroughSubject<String,Never>()
    private var text = ""
    private var itemArray: [Item] = []
 
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = ViewModel()
        self.indicator.isHidden = true
        setUpData()
        self.hideKeyboardWhenTappedAround()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.text = searchText
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        indicator.isHidden = false
        indicator.startAnimating()
        itemArray.removeAll()
        tableView.isHidden = true
        
        if !self.text.isEmpty {
            self.viewModel?.queryByCityName(with: self.text, page: self.page)
        }
        searchBar.resignFirstResponder()
    }
    
    private func hideLoader() {
        self.indicator.isHidden = true
        self.tableView.isHidden = false
        self.indicator.stopAnimating()
    }
    
    private func setUpData() {
        searchBar.delegate = self
        viewModel?.items
            .sink(receiveCompletion: { completion in
                self.showToast(message: "Network Error",
                               font: .systemFont(ofSize: 12.0))
                self.hideLoader()
            }, receiveValue: { result in
                self.hideLoader()
                if let result = result {
                    self.didFetchData(data: result)
                }
            })
            .store(in: &cancellableSet)
    }
    
    private func handleTableViewDataSource(model: ItemDataSource) -> GenericTableViewDataSourceDelegate<Item, TableViewCell> {
        return GenericTableViewDataSourceDelegate<Item, TableViewCell>(
            models: model.searchSection, items: model.searchItems) { (result, cell) in
                cell.attachView(value: result)
            }
    }
    
    private func didFetchData(data: AllItems) {
        itemArray.append(contentsOf: viewModel?
            .setUpItemArrayWithPagination(data: data) ?? [])

        let values: ItemDataSource = .init(data: viewModel?.removeDublicate(itemArray: itemArray))
        
        dataSource = handleTableViewDataSource(model: values)
        setUpTableView(with: data)
    }
    
    private func setUpTableView(with data: AllItems) {
        tableView.delegate = dataSource
        tableView.dataSource = dataSource
        tableView.reloadData()
        self.totalPage = data.pagination?.lastPage ?? 1
        self.page = data.pagination?.currentPage ?? 1
        loadMore()
    }
    
    private func loadMore() {
        
        dataSource?.loadMore = { [weak self] value in
            guard let self = self else { return }
            if value {
                self.page += 1
                if self.page <= self.totalPage {
                    // make Request update Table
                    self.viewModel?.queryByCityName(with: self.text, page: self.page)
                }
            }
        }
    }
}
