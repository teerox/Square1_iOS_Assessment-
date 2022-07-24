//
//  TableViewCell.swift
//  Square1_iOS_Assessment
//
//  Created by Anthony Odu on 2022/7/22.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var countryCode: UILabel!
    
    func attachView<T>(value: T?) {
        if let value = value as? TableViewValue {
            cityName.text = value.name
            countryCode.text = "country: \(value.countryName ?? "")"
        } else {
            if let value = value as? Item {
                cityName.text = value.name
                countryCode.text = "country: \(value.country?.name ?? "")"
            }
        }
        
    }
}
