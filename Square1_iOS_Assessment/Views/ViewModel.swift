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
    let itemsFromDb = CurrentValueSubject<[TableViewValue], Never>([])
    let allMapData = PassthroughSubject<AllMapData, Never>()
    var mapItems: [MapData] = []
    
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
    func queryByCityName(with cityName: String) -> AnyPublisher<ResponseModel, Error>{
        return repository.queryByCityName(with: cityName)
    }
    
    /// Method to get latitude, longitude, city name and country from db
    func getLongitudeAndLatitude() {
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
    
    /// Remove Duplicate from given data
    /// - Parameter itemArray: Data from Api
    /// - Returns: Result without Dplicate
     func removeDuplicate(itemArray: [Item]) -> [Item] {
        var uniquieArray: [Item] = []
           for item in itemArray {
               if !uniquieArray.contains(item) {
                   uniquieArray.append(item)
               }
           }
           return uniquieArray
    }
}
