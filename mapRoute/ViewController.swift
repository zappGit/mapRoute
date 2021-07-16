//
//  ViewController.swift
//  mapRoute
//
//  Created by Артем Хребтов on 16.07.2021.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController {
    
    var annotationsArray = [MKPointAnnotation]()
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var addPlaceButton: UIButton!
    @IBOutlet weak var routeButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        // Do any additional setup after loading the view.
    }
    @IBAction func addPlaceButtonTapped(_ sender: Any) {
        alertAddPlace { [self] text in
            setPin(addressPlace: text)
        }
        
    }
    @IBAction func routeButtonTapped(_ sender: Any) {
        for index in 0...annotationsArray.count - 2 {
            getDirection(startPoint: annotationsArray[index].coordinate,
                         destinationPoint: annotationsArray[index+1].coordinate)
        }
        mapView.showAnnotations(annotationsArray, animated: true)
    }
    @IBAction func deleteButtonTapped(_ sender: Any) {
        annotationsArray = [MKPointAnnotation]()
        mapView.removeOverlays(mapView.overlays)
        mapView.removeAnnotations(mapView.annotations)
        routeButton.isHidden = true
        deleteButton.isHidden = true
    }
    
    private func setPin(addressPlace: String) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(addressPlace) { [self] (placemarks, error) in
            if error != nil {
                alertError()
                return
            }
            guard let placemarks = placemarks else {
                return
            }
            let placemark = placemarks.first
            let annotation = MKPointAnnotation()
            annotation.title = ("\(addressPlace)")
            guard let placemarkLocation = placemark?.location else {
                return
            }
            annotation.coordinate = placemarkLocation.coordinate
            annotationsArray.append(annotation)
            if annotationsArray.count > 2 {
                routeButton.isHidden = false
                deleteButton.isHidden = false
            }
            mapView.showAnnotations(annotationsArray, animated: true)
        }
    }
    private func getDirection(startPoint: CLLocationCoordinate2D, destinationPoint: CLLocationCoordinate2D) {
        let startPoint = MKPlacemark(coordinate: startPoint)
        let destinationPoint = MKPlacemark(coordinate: destinationPoint)
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: startPoint)
        request.destination = MKMapItem(placemark: destinationPoint)
        request.transportType = .walking
        request.requestsAlternateRoutes = true
        
        let direction = MKDirections(request: request)
        
        direction.calculate { [self] (response, error) in
            if error != nil {
                alertError()
                return
            }
            guard let response = response else {
                return
            }
            var minRoute = response.routes[0]
            for route in response.routes {
                minRoute = (route.distance < minRoute.distance) ? route : minRoute
            }
            self.mapView.addOverlay(minRoute.polyline)
        }
        
    }
}

extension ViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay as! MKPolyline)
        renderer.strokeColor = .green
        return renderer
    }
}
