//
//  ItemDataSource.swift
//  Square1_iOS_Assessment
//
//  Created by Anthony Odu on 2022/7/22.
//

import Foundation

class ItemDataSource: NSObject {
    
    var sections: [Int: [TableViewValue]] = [:]
    var searchSection: [Int: [Item]] = [:]
    
    var items: [Int] {
        return sections.keys.sorted()
    }
    
    var searchItems: [Int] {
        return searchSection.keys.sorted()
    }
    
    init<T>(data: T) {
        if let listData = data as? [TableViewValue] {
            for result in listData {
                let items = result.currentPage
                if var stores = sections[items ?? 1] {
                    stores.append(result)
                    sections[items ?? 1] = stores
                } else {
                    sections[items ?? 1] = [result]
                }
            }
        } else {
            if let searchData = data as? [Item] {
                for result in searchData {
                    let items = result.pagination?.currentPage
                    if var stores = searchSection[items ?? 1] {
                        stores.append(result)
                        searchSection[items ?? 1] = stores
                    } else {
                        searchSection[items ?? 1] = [result]
                    }
                }
            }
        }
    }
}
