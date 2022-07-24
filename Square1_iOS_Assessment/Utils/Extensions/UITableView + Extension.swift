//
//  UITableView + Extension.swift
//  Square1_iOS_Assessment
//
//  Created by Anthony Odu on 2022/7/24.
//

import Foundation
import UIKit

public extension UITableView {
    
    func registerHeader<T: UITableViewHeaderFooterView>(_: T.Type, reuseIdentifier: String? = nil) {
        let reuseId = reuseIdentifier ?? "\(T.self)"
        self.register(UINib(nibName: reuseId, bundle: Bundle(for: T.self)), forHeaderFooterViewReuseIdentifier: reuseId)
    }
    
    func dequeueHeader<T: UITableViewHeaderFooterView>(_: T.Type, for Section: Int) -> T {
        guard let cell = dequeueReusableHeaderFooterView(withIdentifier: String(describing: T.self)) as? T
        else { fatalError("Could not dequeue cell with type \(T.self)") }
        return cell
    }
    
    func register<T: UITableViewCell>(_: T.Type, reuseIdentifier: String? = nil) {
        let reuseId = reuseIdentifier ?? "\(T.self)"
        self.register(UINib(nibName: reuseId, bundle: Bundle(for: T.self)), forCellReuseIdentifier: reuseId)
    }
    
    func dequeue<T: UITableViewCell>(_: T.Type, for indexPath: IndexPath? = nil) -> T {
        if let indexPath = indexPath {
            guard
                let cell = dequeueReusableCell(withIdentifier: String(describing: T.self),
                                               for: indexPath) as? T
            else { fatalError("Could not dequeue cell with type \(T.self)") }
            return cell
            
        }
    
        /// In case we're dealing with section Headers. They don't need a special headerClass cell...
        guard let cell = dequeueReusableCell(withIdentifier: String(describing: T.self)) as? T
        else { fatalError("Could not dequeue header cell with type \(T.self)") }
        return cell
    }
}
