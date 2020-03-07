//
//  MapView.swift
//  RevelMini
//
//  Created by Jackie Valadez on 1/31/20.
//  Copyright © 2020 Revel Interview. All rights reserved.
//

import Mapbox
import CoreLocation

class MapView: MGLMapView, MGLMapViewDelegate {
    
    var pinDelegate: MapViewPinDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame, styleURL: URL.init(string: "mapbox://styles/mapbox/streets-v11")!)
        
        self.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        self.delegate = self
        self.zoomLevel = 12
        let defaultLocation = CLLocationCoordinate2D(latitude: 40.6677759, longitude: -74.0122655)
        self.setCenter(defaultLocation, animated: false)
        self.showsUserLocation = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func annotation(at coordinate: CLLocationCoordinate2D, labelText: String) -> MGLPointAnnotation {
        let point = MGLPointAnnotation()
        point.coordinate = coordinate
        point.title = labelText
        return point
    }
    
    func clearMap() {
        guard let allAnnotations = self.annotations else { return }
        removeAnnotations(allAnnotations)
    }
    
    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return true
    }
    
    func mapView(_ mapView: MGLMapView, didSelect annotation: MGLAnnotation) {
        let camera = MGLMapCamera(lookingAtCenter: annotation.coordinate, acrossDistance: 4500, pitch: 0, heading: 0)
        
        mapView.fly(to: camera, withDuration: 1,
                    peakAltitude: 4500, completionHandler: nil)
        
        self.pinDelegate?.didSelectPin(annotation)
    }
    
}
