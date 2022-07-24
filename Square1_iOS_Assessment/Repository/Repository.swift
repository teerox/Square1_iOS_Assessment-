//
//  Repository.swift
//  Square1_iOS_Assessment
//
//  Created by Anthony Odu on 2022/7/21.
//

import Foundation
import Combine
import RealmSwift

class Repository {
    
    private let networkManger: ServiceProtocol!
    private let cacheManager: CacheProtocol!
    private var cancellableSet: Set<AnyCancellable> = []
    private var errorMessages: String = ""
    private var token: NotificationToken?
    
    let items = PassthroughSubject<AllItems?, Error>()
    let itemsFromDb = CurrentValueSubject<[TableViewValue], Never>([])
    
    /// Initialze Network Manager and cache manager here
    /// - Parameters: For Testing Purpose mocked `networkManger` and `cacheManager`
    /// can be injected into this viewModel
    ///   - networkManger: Fetch result from Api
    ///   - cacheManager: fetch and cache result in a local database
    init(with networkManger: ServiceProtocol = NetworkManager.shared(),
         with cacheManager: CacheProtocol = LocalDataCacheManager.shared()
    ) {
        self.networkManger = networkManger
        self.cacheManager = cacheManager
    }
    
    func fetchAllCitiesIncludingCountry(page: Int) {
        let result: AnyPublisher<ResponseModel, Error> = networkManger
            .makeReques(url: "/city",
                        method: .get,
                        parameters: ["page" : page, "include": "country"])
        result
            .sink { completion in
                switch completion {
                case .finished:
                    self.fetchDataFromDB()
                case .failure(let error):
                    self.fetchDataFromDB()
                    self.logError(with: error)
                }
            } receiveValue: { result in
                self.cacheManager.writeToRealm(data: result.data)
            }.store(in: &cancellableSet)
    }
    
    func queryByCityName(with cityName: String, page: Int) {
        
        let result: AnyPublisher<ResponseModel, Error> = networkManger
            .makeReques(url: "/city",
                        method: .get,
                        parameters: ["filter[0][name][contains]": cityName,
                                     "page" : page,"include": "country"])
        
        result
            .sink { completion in
                self.items.send(completion: completion)
            } receiveValue: { result in
                self.items.send(result.data)
            }.store(in: &cancellableSet)
    }
    
    func fetchDataFromDB() {
        var resultArray = [TableViewValue]()
        let result = cacheManager.fetchFromRealm()
        if !result.isEmpty {
            
            resultArray.removeAll()
            for value in result {
                resultArray.append(TableViewValue(value: value))
            }
        }
        itemsFromDb.send(resultArray.sorted(by: { $0.id ?? 0 < $1.id ?? 0 }))
    }

    private func logError( with error: Error) {
        print("Error fetching Data")
    }
}
