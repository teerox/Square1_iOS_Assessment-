//
//  MockedData.swift
//  Square1_iOS_AssessmentTests
//
//  Created by Anthony Odu on 2022/7/21.
//

import Foundation
@testable import Square1_iOS_Assessment


/// This is a sample mocked data reponse from the URL
struct MockedData {
    
    /// Function to get a sample mocked Data
    /// - Returns: ResponseModel struct is a codable response from the api
    func getMockedData(includeCountry: Bool = false) -> ResponseModel? {

        let item = Item(id: 11,
                        name: "Groningen",
                        localName: "Groningen",
                        lat: 53.219167,
                        lng: 6.5666671,
                        createdAt: "2018-01-07 17:08:01",
                        updatedAt: "2018-04-12 21:37:37",
                        countryID: 159,
                        country: includeCountry ? includeCountryToResponse() : nil)
        
        let item2 = Item(id: 7,
                        name: "Haag",
                        localName: "Zuid-Holland",
                        lat: 48.15,
                        lng: 15.5,
                        createdAt: "2018-01-07 17:08:01",
                        updatedAt: "2018-04-12 21:37:37",
                        countryID: 159,
                        country: includeCountry ? includeCountryToResponse() : nil)
        
        let pagination = Pagination(currentPage: 1,
                                    lastPage: 272,
                                    perPage: 15,
                                    total: 4079)
        
        let allItem = AllItems(items: [item,item2],
                               pagination: pagination)
        
        let mockedData = ResponseModel(data: allItem,
                                       time: 1658397976)
        return mockedData
    }
    
    func includeCountryToResponse() -> Country? {
        
        let country = Country(id: 159,
                              name: "Netherlands",
                              code: "NLD",
                              createdAt: "2018-01-07 17:08:01",
                              updatedAt: "2018-01-07 17:08:01",
                              continentID: 2)
        
        return country
    }
}
