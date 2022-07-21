//
//  ResponseModel.swift
//  Square1_iOS_Assessment
//
//  Created by Anthony Odu on 2022/7/21.
//

import Foundation

// MARK: - Welcome
struct ResponseModel: Codable {
    let data: AllItems?
    let time: Double?
}

// MARK: - AllItems
struct AllItems: Codable {
    let items: [Item]
    let pagination: Pagination?
}

// MARK: - Item
struct Item: Codable {
    let id: Int
    let name, localName: String?
    let lat, lng: Double?
    let createdAt: String?
    let updatedAt: String?
    let countryID: Int?
    let country: Country?

    enum CodingKeys: String, CodingKey {
        case id, name
        case localName = "local_name"
        case lat, lng
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case countryID = "country_id"
        case country
    }
}

// MARK: - Country
struct Country: Codable {
    let id: Int?
    let name: String?
    let code: String?
    let createdAt, updatedAt: String?
    let continentID: Int?

    enum CodingKeys: String, CodingKey {
        case id, name, code
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case continentID = "continent_id"
    }
}

// MARK: - Pagination
struct Pagination: Codable {
    let currentPage, lastPage, perPage, total: Int?

    enum CodingKeys: String, CodingKey {
        case currentPage = "current_page"
        case lastPage = "last_page"
        case perPage = "per_page"
        case total
    }
}
