//
//  Reservation.swift
//  RevelMini
//
//  Created by Michael Stromer on 3/7/20.
//  Copyright © 2020 Michael Stromer. All rights reserved.
//

protocol Reservation {
    func changeStatus(status: Vehicle.Status, forColor: ButtonColor, completion: (Vehicle.Status) -> Void)
}
