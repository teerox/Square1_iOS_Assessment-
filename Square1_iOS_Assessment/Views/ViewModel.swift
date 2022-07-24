//
//  ViewModel.swift
//  Square1_iOS_Assessment
//
//  Created by Anthony Odu on 2022/7/21.
//

import Foundation
import Combine

class ViewModel {
    
    private let repository = Repository()
    private var cancellableSet: Set<AnyCancellable> = []
    private var errorMessages: String = ""
    private var itemSetUPPaginationArray: [Item] = []
    let items = PassthroughSubject<AllItems?, Error>()
    let itemsFromDb = CurrentValueSubject<[TableViewValue], Never>([])
    let allMapData = PassthroughSubject<AllMapData, Never>()
    var mapItems: [MapData] = []
    var page: Int = 1
    
    /// Fetch Data from Api
    func fetchDataFromApi(page: Int) {
        repository.fetchAllCitiesIncludingCountry(page: page)
    }
    
    /// Fetch from Cache Data
    func fetchFromDB() {
        repository.fetchDataFromDB()
        repository.itemsFromDb.sink { value in
            if value.isEmpty {
                self.fetchDataFromApi(page: 1)
            } else {
                self.itemsFromDb.send(value)
            }
        }.store(in: &cancellableSet)
    }
    
    /// Query Endpoint by city name
    /// - Parameters:
    ///   - cityName: City name required to make a call
    ///   - page: page number needed for each request
    func queryByCityName(with cityName: String, page: Int) {
        repository.queryByCityName(with: cityName, page: page)
        getQuryResult()
    }
    
    /// Get result from query for view
    private func getQuryResult() {
        repository.items
            .sink { completion in
                self.items.send(completion: completion)
            } receiveValue: { result in
                self.items.send(result)
            }.store(in: &cancellableSet)
    }
    
    /// method to get latitude, longitude, city name and country from db
    func getLngAndLat() {
        repository.fetchDataFromDB()
        repository.itemsFromDb.sink { result in
            self.mapItems = result.map {
                MapData(longitude: $0.lng,
                        latitude: $0.lat,
                        name: $0.name,
                        country: $0.countryName)
            }
            let latitudeData = self.mapItems.map { $0.latitude ?? 0.0 }
            let longitudeData = self.mapItems.map { $0.longitude ?? 0.0 }
            let names = self.mapItems.map { $0.name ?? "" }
            self.allMapData.send( AllMapData(longitude: longitudeData, latitude: latitudeData, name: names))
        }.store(in: &cancellableSet)
    }
    
     func removeDublicate(itemArray: [Item]) -> [Item] {
        var uniquieArray: [Item] = []
           for item in itemArray {
               if !uniquieArray.contains(item) {
                   uniquieArray.append(item)
               }
           }
           return uniquieArray
    }
    
    func setUpItemArrayWithPagination(data: AllItems) -> [Item] {
        
        itemSetUPPaginationArray.removeAll()
        self.itemSetUPPaginationArray.append(contentsOf: data.items)
        
        for (index,_) in itemSetUPPaginationArray.enumerated() {
            itemSetUPPaginationArray[index].pagination = data.pagination
        }
        return itemSetUPPaginationArray
    }
}
