//
//  ViewModelTest.swift
//  Square1_iOS_AssessmentTests
//
//  Created by Anthony Odu on 2022/7/22.
//

import XCTest
import Combine
@testable import Square1_iOS_Assessment

class ViewModelTest: XCTestCase {
    
    var viewModel: ViewModel!
    private var cancellables: Set<AnyCancellable>!

    override func setUpWithError() throws {
        viewModel = ViewModel()
        cancellables = []
    }

    override func tearDownWithError() throws {
        viewModel = nil
    }
    
    func testSearchByCityName() {
        let requestExpectation = expectation(description: "Request should finish")
        var error: Error?
        var resultArray: [Item] = []
        viewModel.queryByCityName(with: "ka")
            .compactMap { $0.data }
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let encounteredError):
                    error = encounteredError
                }
            }, receiveValue: { value in
                resultArray = value.items
                requestExpectation.fulfill()
            })
            .store(in: &cancellables)
        
        wait(for: [requestExpectation], timeout: 10.0)
        
        XCTAssertTrue(!resultArray.isEmpty)
        XCTAssertNil(error)
    }
    
    func testSearchWithIrelivantCityNameReturnsEmpty() {
        let requestExpectation = expectation(description: "Request should finish")
        var error: Error?
        var result: [Item] = []
        viewModel.queryByCityName(with: "zzzzzzzzzzzzzzzzz")
            .compactMap { $0.data }
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let encounteredError):
                    error = encounteredError
                }
            }, receiveValue: { value in
                result = value.items
                requestExpectation.fulfill()
            })
            .store(in: &cancellables)
        
        wait(for: [requestExpectation], timeout: 10.0)
        
        XCTAssertTrue(result.isEmpty)
        XCTAssertNil(error)
    }

    func testRemoveDuplicateFromData() {
        let data = Item(id: 1,
                        name: "lagos",
                        localName: "lagos",
                        lat: 1,
                        lng: 1,
                        createdAt: "",
                        updatedAt: "",
                        countryID: 11,
                        country: Country(id: 11,
                                         name: "Nigeria",
                                         code: "NGN",
                                         createdAt: "",
                                         updatedAt: "",
                                         continentID: 1))
        let data2 = Item(id: 2,
                        name: "Abuja",
                        localName: "abuja",
                        lat: 1,
                        lng: 1,
                        createdAt: "",
                        updatedAt: "",
                        countryID: 11,
                        country: Country(id: 11,
                                         name: "Nigeria",
                                         code: "NGN",
                                         createdAt: "",
                                         updatedAt: "",
                                         continentID: 1))
       let result = viewModel.removeDublicate(itemArray: [data,data,data2])
        XCTAssertEqual(result.count, 2)
    }
}

