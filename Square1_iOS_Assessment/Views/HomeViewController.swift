//
//  ViewController.swift
//  Square1_iOS_Assessment
//
//  Created by Anthony Odu on 2022/7/21.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var listView: UIView!
    @IBOutlet weak var mapView: UIView!
    @IBOutlet weak var segmentControlOutlet: UISegmentedControl!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
   
    @IBAction func segmentControllClick(_ sender: Any) {
        switch segmentControlOutlet.selectedSegmentIndex {
        case 0:
            listView.isHidden = false
            mapView.isHidden = true
        case 1 :
            listView.isHidden = true
            mapView.isHidden = false
        default:
            break
        } 
    }
}

