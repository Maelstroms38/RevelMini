//
//  VehicleViewModel.swift
//  RevelMini
//
//  Created by Michael Stromer on 2/19/20.
//  Copyright © 2020 Michael Stromer. All rights reserved.
//

import Foundation

protocol ReservationDelegate: AnyObject {
    func didChangeStatus(newStatus: Vehicle.Status)
}

enum ButtonColor: String {
    case green, blue
}

// MARK: - ViewModel
class VehicleViewModel {
    private var vehicle: Vehicle
    private var vehicles: [String: Vehicle]
    private let reservation: Reservation
    weak var delegate: ReservationDelegate?
    
    public init(vehicle: Vehicle, vehicles: [String: Vehicle], reservation: Reservation) {
        self.vehicle = vehicle
        self.vehicles = vehicles
        self.reservation = reservation
    }
    
    private var id: String {
        return vehicle.id
    }
    
    private var license: String {
        return vehicle.license
    }
    
    private var latLon: (Double, Double) {
        return vehicle.latLon
    }
    
    private var status: Vehicle.Status {
        return vehicle.status
    }
    
    private var battery: String {
        return String(vehicle.battery)
    }
}

extension VehicleViewModel {
    public func configure(view: VehicleView, vehicleID: String) {
        if let vehicle = self.vehicles[vehicleID] {
            self.vehicle = vehicle
            view.titleLabel.text = id
            view.statusLabel.text = status.rawValue
            view.greenButton.isHidden = false
            view.blueButton.isHidden = false
            view.greenButton.addTarget(self, action: #selector(greenButtonTapped), for: .touchUpInside)
            view.blueButton.addTarget(self, action: #selector(blueButtonTapped), for: .touchUpInside)
            switch status {
            case .Available:
                view.greenButton.setTitle("Start Ride", for: .normal)
                view.blueButton.setTitle("Reserve", for: .normal)
                
            case .Reserved:
                view.greenButton.setTitle("Start Ride", for: .normal)
                view.blueButton.setTitle("Cancel Reservation", for: .normal)
                
            case .Riding:
                view.greenButton.setTitle("Pause Ride", for: .normal)
                view.blueButton.setTitle("End Ride", for: .normal)
                
            case .Paused:
                view.greenButton.setTitle("Resume Ride", for: .normal)
                view.blueButton.setTitle("End Ride", for: .normal)
            }
        }
    }
    @objc private func greenButtonTapped() {
        self.reservation.changeStatus(status: status, forColor: ButtonColor.green) { [weak self] newStatus in
            guard let delegate = self?.delegate else { return }
            vehicle.status = newStatus
            vehicles[id] = vehicle
            delegate.didChangeStatus(newStatus: newStatus)
        }
    }
    @objc private func blueButtonTapped() {
        self.reservation.changeStatus(status: status, forColor: ButtonColor.blue) { [weak self] newStatus in
            guard let strongSelf = self else { return }
            guard let delegate = strongSelf.delegate else { return }
            vehicle.status = newStatus
            vehicles[id] = vehicle
            delegate.didChangeStatus(newStatus: newStatus)
        }
    }
}
