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

    // MARK: - Variables
    private var dataSource: GenericTableViewDataSourceDelegate<Item, TableViewCell>?
    private var viewModel: ViewModel = ViewModel()
    private var publisher: AnyCancellable?
    private let searchText = PassthroughSubject<String, Never>()
  
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        self.hideKeyboardWhenTappedAround()
        setupPublisher()
    }
    
    private func setUpTableView() {
        tableView.delegate = dataSource
        tableView.dataSource = dataSource
        tableView.reloadData()
    }
    
    /// Method used to subscribe to the publisher to recieve data
    private func setupPublisher() {
        self.publisher = searchText
            .debounce(for: .seconds(0.5), scheduler: RunLoop.main)
            .flatMap { value in
                return self.viewModel.queryByCityName(with: value)
                    .catch{_ in Empty() }
                    .map { $0 }
            }
            .compactMap {$0.data}
            .sink(receiveValue: { data in
                self.didFetchData(data: data.items)
            })
    }
    
    private func didFetchData(data: [Item]) {
        let values: ItemDataSource = .init(data: viewModel.removeDuplicate(itemArray: data))
        dataSource = handleTableViewDataSource(model: values)
        setUpTableView()
    }

    private func handleTableViewDataSource(model: ItemDataSource) -> GenericTableViewDataSourceDelegate<Item, TableViewCell> {
        return GenericTableViewDataSourceDelegate<Item, TableViewCell>(
            models: model.searchSection, items: model.searchItems) { (result, cell) in
                cell.attachView(value: result)
            }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if !searchText.isEmpty {
            self.searchText.send(searchText)
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
