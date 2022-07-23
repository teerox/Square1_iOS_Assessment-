//
//  TableViewCell.swift
//  Square1_iOS_Assessment
//
//  Created by Anthony Odu on 2022/7/22.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var cityName: UILabel!
    
    
    func attachView(value: TableViewValue?) {
        cityName.text = value?.name
    }
}
