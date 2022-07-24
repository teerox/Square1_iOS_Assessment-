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
        navigationController?.navigationBar.isHidden = true
        mapView.isHidden = true
    }
   
    @IBAction func segmentControllClick(_ sender: Any) {
        switch self.segmentControlOutlet.selectedSegmentIndex{
        case 0:
            self.moveTList()
        case 1:
            if let viewControler = self.children.first as? MapViewController {
                viewControler.setUpData()
            }
            self.moveToMap()
        default:
            self.moveTList()
        }
    }
    
    private func moveToMap() {
        self.mapView.isHidden = false
        UIView.animate(withDuration: 0.9, delay: 0, options: .curveEaseOut, animations: {
            self.view.superview?.layoutIfNeeded()
        }) { (_) in
            if self.segmentControlOutlet.selectedSegmentIndex == 1 {
                self.listView.isHidden = true
            }
        }
    }
    
    private func moveTList() {
        self.listView.isHidden = false
        UIView.animate(withDuration: 0.9, delay: 0, options: .curveEaseOut, animations: {
            self.view.superview?.layoutIfNeeded()
        }) { (_) in
            if self.segmentControlOutlet.selectedSegmentIndex == 0{
                self.mapView.isHidden = true
            }
        }
    }
}

