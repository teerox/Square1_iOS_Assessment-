//
//  EndPointTest.swift
//  Square1_iOS_AssessmentTests
//
//  Created by Anthony Odu on 2022/7/21.
//

import XCTest
import Alamofire
import Mocker
@testable import Square1_iOS_Assessment

/// Testing the End points using Mocker to asset that the url is
class EndPointTest: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    /// Testing the end point
    func testToGetAllCitiesFromEndpoint() {
        let configuration = URLSessionConfiguration.af.default
        configuration.protocolClasses = [MockingURLProtocol.self] + (configuration.protocolClasses ?? [])
        let sessionManager = Session(configuration: configuration)

        let apiEndpoint = URL(string: "http://connect-demo.mobile1.io/square1/connect/v1/city")!
        let expectedResult = MockedData().getMockedData()
        let requestExpectation = expectation(description: "Request should finish")

        let mockedData = try! JSONEncoder().encode(expectedResult)
        let mock = Mock(url: apiEndpoint, dataType: .json, statusCode: 200, data: [.get: mockedData])
        mock.register()
        
        sessionManager
            .request(apiEndpoint)
            .responseDecodable(of: ResponseModel.self) { (response) in
                XCTAssertNil(response.error)
                XCTAssertTrue(!(response.value?.data?.items.isEmpty ?? false))
                requestExpectation.fulfill()
            }.resume()

        wait(for: [requestExpectation], timeout: 10.0)
    }
    
    /// Testing the end point
    func testToGetAllCitiesFromEndpointByQueryingPage() {
        let configuration = URLSessionConfiguration.af.default
        configuration.protocolClasses = [MockingURLProtocol.self] + (configuration.protocolClasses ?? [])
        let sessionManager = Session(configuration: configuration)

        let apiEndpoint = URL(string: "http://connect-demo.mobile1.io/square1/connect/v1/city?page=20")!
        let expectedResult = MockedData().getMockedData()
        let requestExpectation = expectation(description: "Request should finish")

        let mockedData = try! JSONEncoder().encode(expectedResult)
        let mock = Mock(url: apiEndpoint, dataType: .json, statusCode: 200, data: [.get: mockedData])
        mock.register()
        
        sessionManager
            .request(apiEndpoint)
            .responseDecodable(of: ResponseModel.self) { (response) in
                XCTAssertNil(response.error)
                XCTAssertTrue(!(response.value?.data?.items.isEmpty ?? false))
                requestExpectation.fulfill()
            }.resume()

        wait(for: [requestExpectation], timeout: 10.0)
    }

    func testToGetAllCitiesFromEndpointAndIncludingCountry() {
        let configuration = URLSessionConfiguration.af.default
        configuration.protocolClasses = [MockingURLProtocol.self] + (configuration.protocolClasses ?? [])
        let sessionManager = Session(configuration: configuration)

        let apiEndpoint = URL(string: "http://connect-demo.mobile1.io/square1/connect/v1/city?include=country")!
        let expectedResult = MockedData().getMockedData(includeCountry: true)
        let requestExpectation = expectation(description: "Request should finish")

        let mockedData = try! JSONEncoder().encode(expectedResult)
        let mock = Mock(url: apiEndpoint, dataType: .json, statusCode: 200, data: [.get: mockedData])
        mock.register()
        
        sessionManager
            .request(apiEndpoint)
            .responseDecodable(of: ResponseModel.self) { (response) in
                XCTAssertNil(response.error)
                XCTAssertTrue(response.value?.data?.items.first?.country != nil)
                requestExpectation.fulfill()
            }.resume()

        wait(for: [requestExpectation], timeout: 10.0)
    }
    
    func testToGetAllCityByName() {
        let configuration = URLSessionConfiguration.af.default
        configuration.protocolClasses = [MockingURLProtocol.self] + (configuration.protocolClasses ?? [])
        let sessionManager = Session(configuration: configuration)

        let apiEndpoint = URL(string: "http://connect-demo.mobile1.io/square1/connect/v1/city?filter[0][name][contains]=gro")!
        let expectedResult = MockedData().getMockedData(includeCountry: false)
        let requestExpectation = expectation(description: "Request should finish")

        let mockedData = try! JSONEncoder().encode(expectedResult)
        let mock = Mock(url: apiEndpoint, dataType: .json, statusCode: 200, data: [.get: mockedData])
        mock.register()
        
        sessionManager
            .request(apiEndpoint)
            .responseDecodable(of: ResponseModel.self) { (response) in
                XCTAssertNil(response.error)
                XCTAssertTrue(response.value?.data?.items.first?.name == "Groningen")
                requestExpectation.fulfill()
            }.resume()

        wait(for: [requestExpectation], timeout: 10.0)
    }
    
    func testToGetAllCityByNamePageNumberAndIncludeCountry() {
        let configuration = URLSessionConfiguration.af.default
        configuration.protocolClasses = [MockingURLProtocol.self] + (configuration.protocolClasses ?? [])
        let sessionManager = Session(configuration: configuration)

        let apiEndpoint = URL(
            string: "http://connect-demo.mobile1.io/square1/connect/v1/city?filter[0][name][contains]=gro&page=1&include=country"
        )!
        let expectedResult = MockedData().getMockedData(includeCountry: true)
        let requestExpectation = expectation(description: "Request should finish")

        let mockedData = try! JSONEncoder().encode(expectedResult)
        let mock = Mock(url: apiEndpoint, dataType: .json, statusCode: 200, data: [.get: mockedData])
        mock.register()
        
        sessionManager
            .request(apiEndpoint)
            .responseDecodable(of: ResponseModel.self) { (response) in
                XCTAssertNil(response.error)
                XCTAssertTrue(response.value?.data?.items.first?.name == "Groningen")
                XCTAssertTrue(response.value?.data?.items.first?.country != nil)
                requestExpectation.fulfill()
            }.resume()

        wait(for: [requestExpectation], timeout: 10.0)
    }
}
