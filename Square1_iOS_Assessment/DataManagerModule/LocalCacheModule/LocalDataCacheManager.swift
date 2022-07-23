//
//  LocalDataCacheManager.swift
//  Square1_iOS_Assessment
//
//  Created by Anthony Odu on 2022/7/21.
//

import Foundation
import RealmSwift

protocol CacheProtocol {
    func writeToRealm(data: AllItems?)
    func fetchFromRealm() -> Results<CityAndCountry>
    func deleteData()
}

class LocalDataCacheManager: CacheProtocol {
    
    // Create a shared Instance
    static let _shared = LocalDataCacheManager()
    
    // Shared Function
    class func shared() -> LocalDataCacheManager {
        return _shared
    }
    
    lazy var realm:Realm = {
        return try! Realm()
    }()
    
    func writeToRealm(data: AllItems?) {
        do {
            // Open a thread-safe.
            try realm.write {
                // Make any writes within this code block.
                // Realm automatically cancels this
                // if this code throws an exception. Otherwise,
                // Realm automatically commits the transaction
                // after the end of this code block.
                // Add the instance to the realm.
               
                convertApiResponseToRealmDataModel(data: data)
            }
        } catch let error as NSError {
            // Failed to write to realm.
            print(error,"Error")
        }
    }
    
    func fetchFromRealm() -> Results<CityAndCountry> {
        let result = realm.objects(CityAndCountry.self)
        return result
    }
    
    func convertApiResponseToRealmDataModel(data: AllItems?) {
        
        /// loop throug the data to upadte all local cache values
        for items in data?.items ?? [] {
            let value = CityAndCountry()
            value.id = items.id
            value.name = items.name
            value.localName = items.localName
            value.lat = items.lat
            value.lng = items.lng
            value.countryID = items.countryID
            value.countryName = items.country?.name
            value.countryCode = items.country?.code
            value.continentID = items.country?.continentID
            value.currentPage = data?.pagination?.currentPage
            value.lastPage = data?.pagination?.lastPage
            value.total = data?.pagination?.total
            realm.add(value, update: .all)
        }
    }
    
    func deleteData() {
        try! realm.write {
            realm.deleteAll()
        }
    }
}
