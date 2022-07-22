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
}

class LocalDataCacheManager: CacheProtocol {
    
    // Create a shared Instance
    static let _shared = LocalDataCacheManager()
    
    // Shared Function
    class func shared() -> LocalDataCacheManager {
        return _shared
    }
    
    let realm = try! Realm()
    
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
            value.country?.id = items.country?.id
            value.country?.name = items.country?.name
            value.country?.code = items.country?.code
            value.country?.continentID = items.country?.continentID
            value.currentPage = data?.pagination?.currentPage
            value.lastPage = data?.pagination?.lastPage
            
            realm.add(value, update: .all)
        }
    }
}
