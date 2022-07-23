//
//  Utils.swift
//  Square1_iOS_Assessment
//
//  Created by Anthony Odu on 2022/7/22.
//

import Foundation

class Utils {
    
    static func flag(country:String) -> String {
        let base : UInt32 = 127397
        var value = ""
        for result in country.uppercased().unicodeScalars {
            value.unicodeScalars.append(UnicodeScalar(base + result.value)!)
        }
        return String(value)
    }
}
