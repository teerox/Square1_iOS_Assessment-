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
    @Persisted(primaryKey: true) var id = 0
    @Persisted var name: String?
    @Persisted var localName: String?
    @Persisted var lat: Double?
    @Persisted var lng: Double?
    @Persisted var countryID: Int?
    @Persisted var countryName: String?
    @Persisted var countryCode: String?
    @Persisted var continentID: Int?
    @Persisted var currentPage: Int?
    @Persisted var lastPage: Int?
    @Persisted var total: Int?
}

struct TableViewValue {
    var id: Int?
    var name: String?
    var localName: String?
    var lat: Double?
    var lng: Double?
    var countryID: Int?
    var countryName: String?
    var countryCode: String?
    var continentID: Int?
    var currentPage: Int?
    var lastPage: Int?
    var total: Int?
    
    init(value: CityAndCountry) {
        self.id = value.id
        self.name = value.name
        self.localName = value.localName
        self.lat = value.lat
        self.lng = value.lng
        self.countryID = value.countryID
        self.countryName = value.countryName
        self.countryCode = value.countryCode
        self.continentID = value.continentID
        self.currentPage = value.currentPage
        self.lastPage = value.lastPage
        self.total = value.total
    }
}
