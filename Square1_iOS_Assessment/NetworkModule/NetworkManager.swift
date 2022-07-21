//
//  NetworkManager.swift
//  Square1_iOS_Assessment
//
//  Created by Anthony Odu on 2022/7/21.
//

import Foundation
import Alamofire
import Combine


struct NetworkError: Error {
  let initialError: AFError
  let backendError: BackendError?
}

struct BackendError: Codable, Error {
    let message: String?
}

protocol ServiceProtocol {
    
    /// - Parameters:
    ///   - url: url for request
    ///   - method: methods for POST, GET, PUT and DELETE
    ///   - parameters: request body as dictionary
    ///   - isJSONRequest: if set to true 'encoding: ParameterEncoding! = JSONEncoding.default
    ///                    or false ' encoding: ParameterEncoding = URLEncoding.default
    /// - Returns: returns AnyPublisher with the data response
    func request<T: Codable>(url :String,
                             method: HTTPMethod,
                             parameters: [String:Any]?,
                             encoding: ParameterEncoding) -> AnyPublisher<DataResponse<T, NetworkError>, Never>
}

class NetworkManager: ServiceProtocol {

    // Create a shared Instance
    static let _shared = NetworkManager()
    
    // Shared Function
    class func shared() -> NetworkManager {
        return _shared
    }
    
    private let baseUrl = "http://connect-demo.mobile1.io/square1/connect/v1"
    
    func request<T>(url: String,
                    method: HTTPMethod,
                    parameters: [String : Any]?,
                    encoding: ParameterEncoding) -> AnyPublisher<DataResponse<T, NetworkError>, Never> where T : Decodable, T : Encodable {
        
        let request = AF.request(baseUrl + url, method: method, parameters: parameters, encoding: encoding)
        
        #if DEBUG
            request.response{ response in
                print(response.debugDescription,"")
            }
        #endif
        
        return request
            .validate()
            .publishDecodable(type: T.self)
            .map { response in
                response.mapError { error in
                    let backendError = response.data.flatMap {
                        try? JSONDecoder().decode(BackendError.self, from: $0)
                    }
                    return NetworkError(initialError: error, backendError: backendError)
                }
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
