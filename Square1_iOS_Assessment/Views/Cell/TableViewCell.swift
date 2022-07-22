//
//  TableViewCell.swift
//  Square1_iOS_Assessment
//
//  Created by Anthony Odu on 2022/7/22.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var countryName: UILabel!
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var flagImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func attachView(value: TableViewValue) {
        countryName.text = value.country
        cityName.text = value.name
        flagImage.image = UIImage(named: Utils.flag(country: value.country ?? ""))
    }
}
