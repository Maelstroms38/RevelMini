//
//  Vehicle.swift
//  RevelMini
//
//  Created by Michael Stromer on 2/12/20.
//  Copyright © 2020 Michael Stromer. All rights reserved.
//

import Foundation

struct Vehicle {
    public enum Status: String {
        case Available, Reserved, Riding, Paused
    }
    public let id: String
    public let license: String
    public let latLon: (Double, Double)
    public let battery: Double
    public var status: Status
}


extension Vehicle {
    init?(json: [String: Any]) {
        guard let id = json["id"] as? String,
            let license = json["licensePlate"] as? String,
            let sensors = json["sensors"] as? [String: Any] else { return nil }
        
        guard let lat = sensors["lat"] as? Double,
            let lon = sensors["lng"] as? Double,
            let battery = sensors["batteryLevel"] as? Double else { return nil }
        
        self.id = id
        self.license = license
        self.latLon = (lat, lon)
        self.battery = battery
        self.status = .Available
    }
    
}
