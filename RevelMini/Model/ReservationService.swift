//
//  ReservationService.swift
//  RevelMini
//
//  Created by Michael Stromer on 3/7/20.
//  Copyright © 2020 Michael Stromer. All rights reserved.
//

class ReservationService: Reservation {
    func changeStatus(status: Vehicle.Status, forColor color: ButtonColor, completion: (Vehicle.Status) -> Void) {
        // call to backend
        if color == .green {
            switch status {
                case .Available:
                    completion(Vehicle.Status.Riding)
                    
                case .Reserved:
                    completion(Vehicle.Status.Riding)
                    
                case .Riding:
                    completion(Vehicle.Status.Paused)
                    
                case .Paused:
                    completion(Vehicle.Status.Riding)
            }
        } else if color == .blue {
            switch status {
                case .Available:
                    completion(Vehicle.Status.Reserved)
                    
                case .Reserved:
                    completion(Vehicle.Status.Available)
                    
                case .Riding:
                    completion(Vehicle.Status.Available)
                    
                case .Paused:
                    completion(Vehicle.Status.Available)
            }
        }
    }
}
