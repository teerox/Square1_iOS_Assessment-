//
//  ItemDataSource.swift
//  Square1_iOS_Assessment
//
//  Created by Anthony Odu on 2022/7/22.
//

import Foundation

class ItemDataSource: NSObject {
    var sections: [String: [TableViewValue]] = [:]
    var sections2: [String: [TableViewValue]] = [:]
    
    var items: [String] {
        return sections.keys.sorted()
    }
    
    var indexes: [String] {
        return items
            .map { String($0.first!) }
            .reduce(into: Set<String>(), { $0.insert($1) })
            .sorted()
    }

    init(data: [TableViewValue]) {
        for result in data {
            let items = result.countryName
            if var stores = sections[items ?? ""] {
                stores.append(result)
                sections[items ?? ""] = stores
            } else {
                sections[items ?? ""] = [result]
            }
        }
    }
}
