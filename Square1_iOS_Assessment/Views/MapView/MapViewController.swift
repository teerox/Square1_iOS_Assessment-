//
//  MapViewController.swift
//  Square1_iOS_Assessment
//
//  Created by Anthony Odu on 2022/7/21.
//

import UIKit
import MapKit
import Combine

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    private var cancellableSet: Set<AnyCancellable> = []
    private var viewModel: ViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
    }
    
    func setUpData() {
        viewModel = ViewModel()
        viewModel?.fetchFromDB()
        arrangeDataForLatAndLong()
    }

    func arrangeDataForLatAndLong() {
        setAnotation(latitudes: viewModel?.mapDatas().latitude ?? [],
                     longitudes: viewModel?.mapDatas().longitude ?? [],
                     names: viewModel?.mapDatas().name ?? [])
    }
    
    func setAnotation(latitudes: [Double], longitudes: [Double], names: [String]) {
        let coordinates = zip(latitudes, longitudes).map(CLLocationCoordinate2D.init)
        
        let annotations = zip(coordinates, names)
            .map { (coordinate, name) -> MKPointAnnotation in
                let annotation = MKPointAnnotation()
                
                annotation.coordinate = coordinate
                annotation.title = name
                
                return annotation
            }
        mapView.addAnnotations(annotations)
        mapView.showAnnotations(annotations, animated: true)
    }
}
