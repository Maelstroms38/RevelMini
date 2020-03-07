//
//  ViewController.swift
//  RevelMini
//
//  Created by Michael Stromer on 2/12/20.
//  Copyright © 2020 Michael Stromer. All rights reserved.
//

import UIKit
import Mapbox

protocol MapViewPinDelegate {
    func didSelectPin(_ pin: MGLAnnotation)
}

class ViewController: UIViewController, MapViewPinDelegate {
    
    private var viewModel: VehicleViewModel!
    
    private lazy var mapView: MapView = {
        let mapView = MapView(frame: self.view.bounds)
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.pinDelegate = self
        self.mapView = mapView
        return mapView
    }()
    
    private lazy var vehicleView: VehicleView = {
        let vehicleView = VehicleView(frame: .zero)
        return vehicleView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.addSubview(mapView)
        
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: self.view.topAnchor),
            mapView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            mapView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            mapView.rightAnchor.constraint(equalTo: self.view.rightAnchor)
        ])
        
        self.view.addSubview(vehicleView)
        
        NSLayoutConstraint.activate([
            vehicleView.heightAnchor.constraint(equalToConstant: self.view.bounds.height * 0.25),
            vehicleView.widthAnchor.constraint(equalToConstant: self.view.bounds.width),
            vehicleView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            vehicleView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            vehicleView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
        ])
        
        NSLayoutConstraint.activate([
            vehicleView.stackView.topAnchor.constraint(equalTo: vehicleView.topAnchor),
            vehicleView.stackView.bottomAnchor.constraint(equalTo: vehicleView.bottomAnchor, constant: -20),
            vehicleView.stackView.leftAnchor.constraint(equalTo: vehicleView.leftAnchor),
            vehicleView.stackView.rightAnchor.constraint(equalTo: vehicleView.rightAnchor),
            
            vehicleView.greenButton.widthAnchor.constraint(equalToConstant: self.view.bounds.width * 0.80),
            vehicleView.blueButton.widthAnchor.constraint(equalToConstant: self.view.bounds.width * 0.80),
            
        ])
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // Fetch vehicles from local JSON file
        if let path = Bundle.main.path(forResource: "upstreamVehicles", ofType: "json") {
            fetchVehicles(path)
        }
    }
    
    private func fetchVehicles(_ path: String){
        // Parse data from specified file path
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            let json = try? JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
            if let jsonDictionary = json as? [String: Any] {
                if let results = jsonDictionary["vehicles"] as? [[String: Any]] {
                    var vehicles: [String: Vehicle] = [:]
                    var firstVehicle: Vehicle? = nil
                    for object in results {
                        // Create vehicle from JSON model object
                        if let vehicle = Vehicle(json: object) {
                            if firstVehicle == nil {
                                firstVehicle = vehicle
                            }
                            let pin = self.mapView.annotation(at: CLLocationCoordinate2D(latitude: vehicle.latLon.0, longitude: vehicle.latLon.1), labelText: vehicle.id)
                            vehicles[vehicle.id] = vehicle
                            self.mapView.addAnnotation(pin)
                        }
                    }
                    if let vehicle = firstVehicle {
                        self.viewModel = VehicleViewModel(vehicle: vehicle, vehicles: vehicles, reservation: ReservationService())
                        self.viewModel.delegate = self
                    }
                }
            }
        } catch (let error) {
            print(error)
        }
    }
    
    // MapViewPinDelegate - didSelectPin sends pin data from MapView
    func didSelectPin(_ pin: MGLAnnotation) {
        // Based on selected pin, show vehicle information
        if let vehicleID = pin.title as? String {
            self.viewModel.configure(view: self.vehicleView, vehicleID: vehicleID)
        }
    }
}

extension ViewController: ReservationDelegate {
    
    func didChangeStatus(newStatus: Vehicle.Status) {
        switch newStatus {
        case .Available:
            self.vehicleView.statusLabel.text = newStatus.rawValue
            self.vehicleView.greenButton.setTitle("Start Ride", for: .normal)
            self.vehicleView.blueButton.setTitle("Reserve Ride", for: .normal)
            
        case .Reserved:
            self.vehicleView.statusLabel.text = newStatus.rawValue
            self.vehicleView.greenButton.setTitle("Start Ride", for: .normal)
            self.vehicleView.blueButton.setTitle("Cancel Reservation", for: .normal)
            
        case .Riding:
            self.vehicleView.statusLabel.text = newStatus.rawValue
            self.vehicleView.greenButton.setTitle("Pause Ride", for: .normal)
            self.vehicleView.blueButton.setTitle("End Ride", for: .normal)
            
        case .Paused:
            self.vehicleView.statusLabel.text = newStatus.rawValue
            self.vehicleView.greenButton.setTitle("Resume Ride", for: .normal)
            self.vehicleView.blueButton.setTitle("End Ride", for: .normal)
        }
    }
}
