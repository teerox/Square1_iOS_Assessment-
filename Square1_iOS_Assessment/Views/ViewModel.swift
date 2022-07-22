//
//  ViewModel.swift
//  Square1_iOS_Assessment
//
//  Created by Anthony Odu on 2022/7/21.
//

import Foundation
import Combine
import Alamofire

class ViewModel {
    
    private let repository = Repository()
    private var cancellableSet: Set<AnyCancellable> = []
    private var errorMessages: String = ""
    
    let items = CurrentValueSubject<[Item], Never>([])
    let itemsFromDb = CurrentValueSubject<[TableViewValue], Never>([])
    var mapItems: [MapData] = []
    
    /// Fetch Data from Api
    /// - Parameter page: page number needed for each request
    func fetchDataFromApi(page: Int) {
        repository.fetchAllCitiesIncludingCountry(page: page)
    }
    
    /// Fetch from Cache Data
    func fetchFromDB() {
        repository.fetchDataFromDB()
    }
    
    /// Query Endpoint by city name
    /// - Parameters:
    ///   - cityName: City name required to make a call
    ///   - page: page number needed for each request
    func queryByCityName(with cityName: String, page: Int) {
        repository.queryByCityName(with: cityName, page: page)
    }
    
    /// Method to update items from db available for view
    func updateItem() {
        itemsFromDb.send(repository.itemsFromDb.value)
    }
    
    /// Get result from query for view
    func getQuryResult() {
        repository.items.sink { completion in
            switch completion {
            case .finished:
                print("Received finished")
            case .failure(let error):
                self.logError(with: error)
                self.errorMessages = error.backendError == nil ?
                "Check Internet connection" :
                error.backendError!.message ?? "Error"
            }
        } receiveValue: { result in
            self.items.send(result)
        }.store(in: &cancellableSet)
    }
    
    /// Get data for the map view
    /// - Returns: `AllMapData` reponse used to puplate annotation on the map view
    func mapDatas() -> AllMapData {
        self.getLngAndLat()
        let latitudeData = self.mapItems.map { $0.latitude ?? 0.0 }
        let longitudeData = self.mapItems.map { $0.longitude ?? 0.0 }
        let names = self.mapItems.map { $0.name ?? "" }
        return AllMapData(longitude: longitudeData, latitude: latitudeData, name: names)
    }
    
    /// method to get latitude, longitude, city name and country from db
    private func getLngAndLat() {
        repository.itemsFromDb.sink { result in
            self.mapItems = result.map {
                MapData(longitude: $0.lng,
                        latitude: $0.lat,
                        name: $0.name,
                        country: $0.country)
            }
        }.store(in: &cancellableSet)
    }
    
    /// Custom Logger
    /// - Parameter error: error from api request
    private func logError( with error: NetworkError ) {
        error.backendError == nil ?
        print(error.initialError.localizedDescription) :
        print(error.backendError!.message ?? "Error")
    }
}
