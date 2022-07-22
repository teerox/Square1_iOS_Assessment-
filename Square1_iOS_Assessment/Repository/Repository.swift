//
//  Repository.swift
//  Square1_iOS_Assessment
//
//  Created by Anthony Odu on 2022/7/21.
//

import Foundation
import Combine
import Alamofire
import RealmSwift

class Repository {
    
    private let networkManger: ServiceProtocol!
    private let cacheManager: CacheProtocol!
    private var cancellableSet: Set<AnyCancellable> = []
    private var errorMessages: String = ""
    private var token: NotificationToken?
    
    let items = PassthroughSubject<[Item], NetworkError>()
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
        let result: AnyPublisher<DataResponse<ResponseModel,
                                              NetworkError>, Never> = networkManger
            .request(url: "/city",
                     method: .get,
                     parameters: ["page" : page, "include": "country"],
                     encoding: URLEncoding.queryString)
        
        result
            .sink { result in
            if result.error != nil {
                self.logError(with: result.error!)
                self.errorMessages = result
                    .error!.backendError == nil ? "Check Internet connection" : result
                    .error!.backendError!.message ?? "Error"
            } else {
                self.cacheManager.writeToRealm(data: result.value?.data)
            }
        }.store(in: &cancellableSet)
    }
 
    func queryByCityName(with cityName: String, page: Int) {
        let result: AnyPublisher<DataResponse<ResponseModel,
                                              NetworkError>, Never> = networkManger
            .request(url: "/city",
                     method: .get,
                     parameters: ["filter[0][name][contains]": cityName,"page" : page,"include": "country"],
                     encoding: URLEncoding.queryString)
        result
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .sink { result in
            if result.error != nil {
                self.items.send(completion: .failure(result.error!))
            } else {
                self.items.send(result.value?.data?.items ?? [])
            }
        }
            .store(in: &cancellableSet)
    }
    
    func fetchDataFromDB() {
       let result = cacheManager.fetchFromRealm()
        
        token = result.observe({ [weak self] changes in
            self?.itemsFromDb.value = result
                .map(TableViewValue.init)
                .sorted(by: { $0.id ?? 0 > $1.id ?? 0 })
        })
    }
    
    private func logError( with error: NetworkError ) {
        error.backendError == nil ?
        print(error.initialError.localizedDescription) :
        print(error.backendError!.message ?? "Error")
    }
}
