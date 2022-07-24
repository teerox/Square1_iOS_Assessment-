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
    
    func testThatApiRequestDataIsAddedToDB() {
        let requestExpectation = expectation(description: "Request should finish")
        viewModel.fetchFromDB()
        viewModel.itemsFromDb
            .sink(receiveValue: { result in
                XCTAssertTrue(!result.isEmpty)
                requestExpectation.fulfill()
            })
            .store(in: &cancellables)
        wait(for: [requestExpectation], timeout: 10.0)
    }
    
    func testSearchByCityName() {
        let requestExpectation = expectation(description: "Request should finish")
        viewModel.queryByCityName(with: "ka", page: 1)
        viewModel.items
            .sink(receiveValue: { result in
                XCTAssertTrue(!result.items.isEmpty)
                requestExpectation.fulfill()
            })
            .store(in: &cancellables)
        wait(for: [requestExpectation], timeout: 10.0)
    }

}
