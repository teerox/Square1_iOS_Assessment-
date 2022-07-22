//
//  RealmModel.swift
//  Square1_iOS_Assessment
//
//  Created by Anthony Odu on 2022/7/21.
//

import Foundation
import RealmSwift

// MARK: - CityAndCountry
class CityAndCountry: Object {
    @Persisted var id: Int?
    @Persisted var name: String?
    @Persisted var localName: String?
    @Persisted var lat: Double?
    @Persisted var lng: Double?
    @Persisted var countryID: Int?
    @Persisted var country: CountryValue?
    @Persisted var currentPage: Int?
    @Persisted var lastPage: Int?
}

// MARK: - CountryValue
class CountryValue: Object {
    @Persisted var id: Int?
    @Persisted var name: String?
    @Persisted var code: String?
    @Persisted var continentID: Int?
}

struct TableViewValue {
    var id: Int?
    var name: String?
    var localName: String?
    var lat: Double?
    var lng: Double?
    var countryID: Int?
    var country: String?
    var currentPage: Int?
    var lastPage: Int?
    
    init(value: CityAndCountry) {
        self.id = value.id
        self.name = value.name
        self.localName = value.localName
        self.lat = value.lat
        self.lng = value.lng
        self.countryID = value.countryID
        self.country = value.country?.name
        self.currentPage = value.currentPage
        self.lastPage = value.lastPage
    }
}
